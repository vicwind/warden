class TestCase < ActiveRecord::Base
  attr_accessible :feature_file_path, :feature_name, :last_run_at,
    :name, :register_at, :tc_id, :warden_project_id, :warden_project
  belongs_to :warden_project
  has_many :test_case_run_infos


end
