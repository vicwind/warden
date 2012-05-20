class CreateTestCaseRunInfos < ActiveRecord::Migration
  def change
    create_table :test_case_run_infos do |t|
      t.with_options(:null => false) do |tt|
        tt.string :status

        #foreign keys
        tt.integer :test_case_id
        tt.integer :test_run_job_id
        tt.integer :test_run_history_id
      end

      t.string :tags
      t.text :test_case_log
      t.text :external_data
      t.integer :number_of_steps
      t.timestamp :end_at
      t.timestamp :start_at
      t.timestamps
    end
  end
end
