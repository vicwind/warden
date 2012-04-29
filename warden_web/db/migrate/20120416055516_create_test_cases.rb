class CreateTestCases < ActiveRecord::Migration
  def change
    create_table :test_cases do |t|
      t.with_options(:null => false) do |tt|
        tt.string :name
        tt.string :feature_name
        tt.string :feature_file_path
        tt.timestamp :register_at
        tt.integer :tc_id

        #these are foreign keys
        tt.integer :warden_project_id
      end

      t.timestamp :last_run_at
      t.timestamps
    end
  end
end

