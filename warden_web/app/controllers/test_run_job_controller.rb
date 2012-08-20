class TestRunJobController < ApplicationController
  include ActionView::Helpers::NumberHelper

  respond_to :html, :xml, :json, :js

  def index
    if request.xhr?
      parse_pagenation_and_sorting_params
      @sort_order = @sort_order.empty? ? 'created_at DESC' : @sort_order

      @all_test_run_job = TestRunJob.limit(@limit).offset(@offset).order(@sort_order).find(:all)
      @total = TestRunJob.count
    end

    respond_to do |format|
      format.html
      format.json { render :json => {
          collection: @all_test_cases_info,
          total: @total
        }
      }
    end
  end

  def get_test_run_job_with_tc_info
    parse_pagenation_and_sorting_params

    @sort_order = @sort_order.empty? ? 'created_at DESC' : @sort_order

    @all_test_run_job = TestRunJob.includes(:test_case_run_infos).limit(@limit).offset(@offset).order(@sort_order).
      find(:all).collect do |job|
        number_of_passed = 0
        number_of_failed = 0
        number_of_queued = 0
        total_number_of_test_cases = job.test_case_run_infos.size
        job.test_case_run_infos.each do |tc_run_info|
          if tc_run_info.status == "Passed"
            number_of_passed += 1
          elsif tc_run_info.status == 'Queued'
            number_of_queued += 1
          elsif tc_run_info.status == 'Failed'
            number_of_failed += 1
          end
        end

        pass_rate = total_number_of_test_cases == 0 ?
          0 : number_of_passed / total_number_of_test_cases.to_f * 100.00

        job.attributes.merge({
          :total_number_of_test_cases => total_number_of_test_cases,
          :pass_rate => number_with_precision(pass_rate, :precision => 0),
          :number_of_queued => number_of_queued,
          :number_of_passed => number_of_passed,
          :number_of_failed => number_of_failed
        })
      end

    respond_with({
      collection: @all_test_run_job,
      total: TestRunJob.count
    })
    #respond_with(@all_test_run_job)
  end
end
