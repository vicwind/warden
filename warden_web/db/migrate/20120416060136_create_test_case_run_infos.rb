class CreateTestCaseRunInfos < ActiveRecord::Migration
  def change
    create_table :test_case_run_infos do |t|
      t.with_options(:null => false) do |tt|
        tt.timestamp :start_at
        tt.string :status
        tt.string :tags
        tt.text :external_data
        tt.text :test_case_log
        tt.timestamp :end_at
        tt.integer :number_of_steps

        #foreign keys
        tt.integer :test_case_id
        tt.integer :test_run_job_id
        tt.integer :test_run_history_id
      end

      t.timestamps
    end
  end
end
