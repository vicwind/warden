class TestRunJobController < ApplicationController
  respond_to :html, :xml, :json, :js

  def index
    @all_test_run_job = TestRunJob.find(:all)

    respond_with(@all_test_run_job)

  end
end
