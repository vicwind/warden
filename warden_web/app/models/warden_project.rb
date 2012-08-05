class WardenProject < ActiveRecord::Base
  attr_accessible :name, :project_type
  has_many :test_cases

  #use class instance variables in place of class variable
  class << self
    def projects_path
      @projects_path = @projects_path || "#{ENV['WARDEN_HOME']}/projects"
    end
  end

  def self.get_all_suite_file_paths
    projects_path = WardenProject.projects_path
    Dir.glob("#{projects_path}/**/*.suite") #get all the suite files in all projects
  end

  def self.calculate_projects_status(env)
    calculated_projects = []
    WardenProject.all.each{ |project|
      calculated_projects.push( WardenProject::calculate_project_status(project.id, env) )
    }
    calculated_projects
  end

  # Grab only the testcases that have run today (anything after midnight)
  def self.calculate_project_status(project_id, env)
    jobs = []
    passed = []
    failed = []
    temp = {}

    e = Time.now.midnight..(Time.now.midnight+1.day)

    # Grab id's of todays cron jobs for specified environment
    temp_jobs = TestRunJob.all :joins => :test_case_run_infos, :conditions => {:name=>"daily_cron", :app_environment=>env, :updated_at=>e}
    temp_jobs.each { |job| jobs.push(job.id) }
    jobs = jobs.uniq

    # Get the current status for testcases based on job id
    jobs.each { |job|
      passed.push(TestCase.all :joins => :test_case_run_infos, :conditions => {:warden_project_id=>project_id,"test_case_run_infos.status"=>"Passed","test_case_run_infos.test_run_job_id"=>job, "test_case_run_infos.updated_at"=>e})
      failed.push(TestCase.all :joins => :test_case_run_infos, :conditions => {:warden_project_id=>project_id,"test_case_run_infos.status"=>"Failed","test_case_run_infos.test_run_job_id"=>job, "test_case_run_infos.updated_at"=>e})
    }

    #return data

    #data = calculate_project_trend(project_id,env,2)

    temp["id"]      = project_id
    temp["env"]     = env
    temp["name"]    = WardenProject.where(:id=>project_id).first.name
    temp["passed"]  = passed.flatten.length
    temp["failed"]  = failed.flatten.length

    #temp["passed"]  = data["passed"][Time.now.strftime("%m/%d/%Y")]
    #temp["failed"]  = data["failed"][Time.now.strftime("%m/%d/%Y")]

    temp["total"]   = temp["passed"] + temp["failed"]

    temp
  end

  # Grab all pass/failures for the trend graph. Optionally you can submit a span length with the
  # default being 1 week.

  def self.calculate_project_trend(project_id, env, span=7)

    temp   = {}
    temp["passed"] = Hash.new(0)
    temp["failed"] = Hash.new(0)

    temp_date = Hash.new(0)
    temp["failed_scenarios"] = []
    jobs = []

    temp["name"]    = WardenProject.where(:id=>project_id).first.name
    temp["id"]      = project_id

    # select a date range given the information provided
    e = (Time.now.midnight - span.day)..(Time.now.midnight+1.day)

    # Check all job id's that occur in that span with 'cron' in the name
    temp_jobs = TestRunJob.all :joins => :test_case_run_infos, :conditions => {:name=>"daily_cron", :app_environment=>env, :updated_at=>e}
    temp_jobs.each { |job| jobs.push(job.id) }

    # If there aren't any jobs that qualify, then the last span period should have 0 testcases run
    if jobs.size > 0

      jobs = jobs.uniq

      last_job = jobs.max

      # For every job found, add the date of the job and the successes/failures for each respective date
      jobs.each { |job|

        passed_testcases = TestCase.all :joins => :test_case_run_infos, :conditions =>{:warden_project_id=>project_id, "test_case_run_infos.status"=>"Passed", "test_case_run_infos.test_run_job_id"=>job}

        passed_testcases.each { |testcase|
          date_run = testcase.test_case_run_infos.where(:test_run_job_id=>job).first.updated_at
          temp["passed"][date_run.strftime("%m/%d/%Y")] += 1
        }

        failed_testcases = TestCase.all :joins => :test_case_run_infos, :conditions =>{:warden_project_id=>project_id, "test_case_run_infos.status"=>"Failed", "test_case_run_infos.test_run_job_id"=>job}

        failed_testcases.each { |testcase|
          date_run = testcase.test_case_run_infos.where(:test_run_job_id=>job).first.updated_at
            temp["failed"][date_run.strftime("%m/%d/%Y")] += 1
            if job == last_job
              # Grab the Log of the failed testcase
              log = testcase.test_case_run_infos.where(:test_run_job_id=>job).first.test_case_log

              # Add any external data if there any
              log << "\n #{testcase.test_case_run_infos.where(:test_run_job_id=>job).first.external_data}"

              temp["failed_scenarios"].push( log )
            end
        }
      }

      return temp
    else
      for i in span.downto(1)
        day_run = Time.now.midnight - i.day
        temp["passed"][day_run.strftime("%m/%d/%Y")] = 0
        temp["failed"][day_run.strftime("%m/%d/%Y")] = 0
      end
    end

    temp
  end

  def self.get_projects_in_job_statistics(job_id)
    @project_passed_status = Hash.new(0)
    @project_failed_status = Hash.new(0)
    @project_queued_status = Hash.new(0)
    @project_failed_tcs    = Hash.new([])

    @sort_order = 'created_at DESC'

    TestRunJob.find(job_id).test_case_run_infos.each do |tc_run_info|
      project = TestCase.find(tc_run_info.test_case_id).warden_project.name
      if tc_run_info.status == "Passed"
        @project_passed_status[project] += 1
      elsif tc_run_info.status == 'Queued'
        @project_queued_status[project] += 1
      elsif tc_run_info.status == 'Failed'
        tc_name = "#{TestCase.find(tc_run_info.test_case_id).feature_name} : #{TestCase.find(tc_run_info.test_case_id).name}" 
        @project_failed_tcs[project].push(tc_name)
        @project_failed_status[project] += 1
      end
    end

    # Setup output 
    [ @project_passed_status, @project_queued_status, @project_failed_status, @project_failed_tcs, ]
  end

end
