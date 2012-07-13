class TestCaseController < ApplicationController

  WARDEN_PROJECTS_PATH = "#{ENV['WARDEN_HOME']}/projects"

  respond_to :html, :xml, :json, :js

  def index

    parse_pagenation_and_sorting_params
    filter_chaning = params["filter_chaining"].blank? ? 'OR' : params["filter_chaining"]
    filter_type = params["filter_type"].blank? ? 'like' : params["filter_type"]
    test_case_model = parse_filter_params(TestCase,
      filter_chaining: filter_chaning, filter_type: filter_type)

    @all_test_cases = test_case_model.includes(:warden_project).limit(@limit).offset(@offset).order(@sort_order).find(:all)

    @total_size = test_case_model.includes(:warden_project).count

    respond_to do |format|
      format.html
      format.json { render :json => {
          collection: @all_test_cases,
          total: @total_size
        }.to_json(:include => :warden_project)
      }
    end
    #respond_with(@all_test_cases)
  end

  def show
    @test_case = TestCase.find(params[:id])

    # respond_to do |format|
    #   format.html # show.html.erb
    #   format.xml  { render :xml => @test_case  }
    #   format.json { render :json => @test_case  }
    # end
    respond_with(@test_case)
  end

  def extjs_tree
    @all_test_cases = TestCase.includes(:warden_project).find(:all)

    first_level_children = []
    @test_case_tree = {
      root: {
        expanded: true,
        text: "Test case folder",
        children: first_level_children
      }
    }

    project_names = {}
    project_suite_file_paths = WardenProject.get_all_suite_file_paths()
    @all_test_cases.each do |tc|
      unless project_names.has_key? tc.warden_project.name
        project_names[tc.warden_project.name] = []
      end

      if !project_names[tc.warden_project.name].find{ |tree_leaf|
        tree_leaf[:text] == tc.feature_name}
        project_names[tc.warden_project.name].push({
          text: tc.feature_name,
          leaf: true
        })

      end
    end

    project_names.each do |project_name, tcs|

      project_suite_file_paths.
        grep(/#{project_name}/).each do |suite_file_path|

        suite_file_relative_path =
          suite_file_path.sub(/.*#{WARDEN_PROJECTS_PATH}/,'')
        tcs.push({
          text: suite_file_path.split('/').last,
          suite_path: suite_file_relative_path,
          leaf: true
        })
        end

      first_level_children << {
        text: project_name,
        children: tcs,
        cls: 'suite',
        checked: true
      }

    end

    respond_with( first_level_children )
  end

  def run_test_job()
    tc_ids = params[:tc_ids]

    tc_ids = get_tc_ids_from_suite_file(WARDEN_PROJECTS_PATH + params[:suite_file_path]) if tc_ids.blank?

    job_name = (params[:job_name].present?) ?
      params[:job_name] : "Test job #{Time.now}"
    #create a new job object and call run with a list of tc_id array
    new_test_job = TestRunJob.new({
      app_environment: params[:app_environment],
      name: job_name,
      queue_name: "default",
      run_node: "localhost",
      schedule_at: Time.now,
      status: 'schedule',
      schedule_by: "no_body",
      job_type: 'On Demand'
    })

    #lanuch and run the job
    new_test_job.run(tc_ids)
    render :text=>"Good to Go!"
  end

  def test_case_search_suguession
    suguession = []
    project_names = WardenProject.select(:name)
    suguession = suguession | project_names.collect(&:name)
    all_test_cases = TestCase.select("feature_name, name")
    all_test_cases.each do |tc|
      suguession << tc.feature_name
      suguession << tc.name
    end
    suguession = suguession.uniq.inject([]) do |collection, entry|
      collection << { name: entry}
    end
    respond_with(suguession)
  end

  ###################
  # Integration actions from Ray's project
  # TODO: This is needed for rewrite
  ###################
  # def trend
  #   @qa_data         = MWarden::calculate_projects_status("qa")
  #   @staging_data    = MWarden::calculate_projects_status("staging")
  #   @production_data = MWarden::calculate_projects_status("prd")
  # end

  # def project
  #   # Make sure id exists
  #   project_id = params[:id]

  #   project = MWarden::Warden_Project.where(:id=>project_id).first

  #   # Gather data about the project
  #   @project_data = MWarden::calculate_project_status(project_id)

  #   project_output_page = "/latest_run/#{project.environment}/#{project.project_name.gsub(' ','_').gsub('.','_')}_#{project.environment}.html"

  #   if File.exists?(File.dirname(__FILE__) + '/public' + project_output_page)
  #     @project_data["cuke_url"] = "/latest_run/#{project_id}"
  #   end
  # end

  ############END#################

  protected
  def get_tc_ids_from_suite_file(suite_file_path)
    tc_ids = []
    open(suite_file_path).each_line do |line|
      tc_ids << line.strip if !line.blank?
    end
    tc_ids
  end
end
