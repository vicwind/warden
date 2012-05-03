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
    job_id = params[:job_id].to_i
    @all_test_cases_info =
      TestCaseRunInfo.includes({:test_case => :warden_project},
                               :test_run_history).
                               where('test_run_job_id = ?', job_id)

    respond_to do |format|
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


end
