class CreateTestRunJobs < ActiveRecord::Migration
  def change
    create_table :test_run_jobs do |t|
      t.with_options(:null => false) do |tt|
        tt.string :name
        tt.timestamp :schedule_at
        tt.string :schedule_by
        tt.string :status
        tt.string :job_type
        tt.string :run_node
        tt.string :queue_name
        tt.string :app_environment
      end

      t.timestamp :start_at
      t.timestamps
    end
  end
end
