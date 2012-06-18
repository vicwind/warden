class AddScreenCaptureLinksToTestCaseRunInfos < ActiveRecord::Migration
  def change
    add_column :test_case_run_infos, :screen_capture_links, :text
  end
end
