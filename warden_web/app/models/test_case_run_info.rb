class TestCaseRunInfo < ActiveRecord::Base
  attr_accessible :end_at, :external_data, :number_of_steps,
    :start_at, :status, :tags, :test_case_log,
    :test_case, :test_run_job, :test_run_history,
    :screen_capture_links #relational links
  belongs_to :test_run_job
  belongs_to :test_case
  belongs_to :test_run_history

end
