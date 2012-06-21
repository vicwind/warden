class TestCaseRunInfoController < ApplicationController
  respond_to :html, :xml, :json, :js

  def index
    @all_test_cases_info =
      TestCaseRunInfo.includes({:test_case => :warden_project}, :test_run_history).find(:all)

    respond_to do |format|
      format.html
      format.json { render :json => @all_test_cases_info.
        to_json(:include => {
          :test_case => {
            :include => {:warden_project => {}}
          },
          :test_run_history => {}
        })
      }
    end
  end

  def update
    @record = TestCaseRunInfo.find(params[:id])

    @record.update_attributes(params[:test_case_run_info])

    respond_with(@record)
  end

  def get_data_by_job_id
    parse_pagenation_and_sorting_params

    job_id = params[:job_id].to_i
    @all_test_cases_info =
      TestCaseRunInfo.includes({:test_case => :warden_project},
        :test_run_history).limit(@limit).offset(@offset).order(@sort_order).
        where('test_run_job_id = ?', job_id)

    @number_of_test_case = TestCaseRunInfo.where('test_run_job_id = ?', job_id).count

    respond_to do |format|
      format.json do render :json =>{
          collection: @all_test_cases_info,
          total: @number_of_test_case
        }.to_json(:include => {
            :test_case => {
              :include => {:warden_project => {}}
            },
            :test_run_history => {}
        })
      end
    end
  end

  def show_log
    @record = TestCaseRunInfo.find(params[:id])
  end
end
