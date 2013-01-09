class AddIndciesToTables < ActiveRecord::Migration
  def change
    transaction do
      add_index :warden_projects, :name
      add_index :warden_projects, :project_type
      add_index :warden_projects, :created_at
      add_index :warden_projects, :updated_at

      add_index :test_cases, :name
      add_index :test_cases, :feature_name
      add_index :test_cases, :feature_file_path
      add_index :test_cases, :tc_id
      add_index :test_cases, :warden_project_id
      add_index :test_cases, :register_at
      add_index :test_cases, :created_at
      add_index :test_cases, :updated_at
      add_index :test_cases, :last_run_at

      add_index :test_run_jobs, :name
      add_index :test_run_jobs, :schedule_at
      add_index :test_run_jobs, :schedule_by
      add_index :test_run_jobs, :status
      add_index :test_run_jobs, :job_type
      add_index :test_run_jobs, :run_node
      add_index :test_run_jobs, :queue_name
      add_index :test_run_jobs, :app_environment
      add_index :test_run_jobs, :created_at
      add_index :test_run_jobs, :updated_at
      add_index :test_run_jobs, :start_at

      add_index :test_case_run_infos, :status
      add_index :test_case_run_infos, :test_case_id
      add_index :test_case_run_infos, :test_run_job_id
      add_index :test_case_run_infos, :test_run_history_id
      add_index :test_case_run_infos, :tags
      add_index :test_case_run_infos, :number_of_steps
      add_index :test_case_run_infos, :end_at
      add_index :test_case_run_infos, :start_at
      add_index :test_case_run_infos, :created_at
      add_index :test_case_run_infos, :updated_at

      add_index :test_run_histories, :run_sequence
      add_index :test_run_histories, :is_last_run
    end
  end
end
