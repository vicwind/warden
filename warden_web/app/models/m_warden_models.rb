module MWarden

  class MWarden_db < ActiveRecord::Base
    self.abstract_class = true
    establish_connection 'mwarden_db'
  end

  class Warden_Project < MWarden_db
    has_many :scenarios
  end

  class Scenario < MWarden_db
    belongs_to :warden_project, :class_name => "Warden_Project", :foreign_key => "warden_project_id"
    belongs_to :test_run_data, :class_name => "Test_Run_Data", :foreign_key => "test_run_id"
  end

  class Test_Run_Data < MWarden_db
    has_one :scenario, :class_name => "Scenario", :foreign_key => "scenario_id"
  end

  def calculate_all_projects_status
    @calculated_projects = []

    Warden_Project.all.each { |project| 
      temp = {}
      temp["id"]       = project.id
      temp["env"]      = project.environment
      temp["name"]     = project.project_name
      temp["total"]    = Scenario.where(:warden_project_id =>project.id).size
      temp["last_run"] = project.last_run

      counter = 0

      Scenario.where(:warden_project_id=>project.id).each { |scenario|
        counter +=1 if ( scenario.test_run_data && scenario.test_run_data.status == "Failed" )
      }

      temp["failed"] = counter
      temp["passed"] = temp["total"] - counter

      @calculated_projects.push(temp)
    }
    @calculated_projects
  end

  def self.calculate_projects_status(env)
    @calculated_projects = []

    Warden_Project.where( :environment=>env ).reorder('project_name').each { |project| 
      temp = {}
      temp["id"]       = project.id
      temp["name"]     = project.project_name
      temp["total"]    = Scenario.where(:warden_project_id =>project.id).size
      temp["last_run"] = project.last_run

      counter = 0

      Scenario.where(:warden_project_id =>project.id).each { |scenario|
        counter +=1 if scenario.test_run_data.status == "Failed"
      }

      temp["failed"] = counter
      temp["passed"] = temp["total"] - counter

      @calculated_projects.push(temp)
    }
    @calculated_projects
  end


  #This needs to grab trending:
  # The first dataset includes successes and dates 
  # The second dataset includes failures dates

  #TODO: Not complete
  def self.calculate_project_status(project_id)
    temp   = {}
    passed = Hash.new(0)
    failed = Hash.new(0)

    # There is a known problem with this, test runs can be counted multiple times in a given day instead of once
    # potential fix is to make sure that the value is only recorded if it has the latest timestamp for a given
    # day.

    temp_date = Hash.new(0)

    project = Warden_Project.where(:id=>project_id).first
    temp["env"] = project.environment

    Scenario.where(:warden_project_id=>project_id).each { |scenario|

      test_run_data = Test_Run_Data.where(:scenario_id=>scenario.id)

      test_run_data.each { |test_run|
        #find the latest interaction
        if( temp_date[test_run.date_run.strftime("%m/%d/%Y")].to_i < test_run.date_run.to_i )                            
          temp_date[test_run.date_run.strftime("%m/%d/%Y")] = test_run.date_run
        end   
      }  

      #only record the latest interaction
      test_run_data.each { |test_run|
        if( temp_date[test_run.date_run.strftime("%m/%d/%Y")].eql?(test_run.date_run) )                            
          if test_run.status == "Passed"
            passed[test_run.date_run.strftime("%m/%d/%Y")] += 1
          else
            failed[test_run.date_run.strftime("%m/%d/%Y")] += 1         
          end
        end
      }        
    }

    temp["name"]    = Warden_Project.where(:id=>project_id).first.project_name
    temp["id"]      = project_id
    temp["passed"]  = passed
    temp["failed"]  = failed

    temp        
  end
end
