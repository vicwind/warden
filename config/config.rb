module Warden
  module Config

    #Uses test case manager to register scenarios
    ENABLE_TEST_CASE_REGISTRATION = true

    WEB_BASE_URL = "http://localhost:5000"

    SCREEN_CAPTURE_DIR = "#{ENV["WARDEN_HOME"]}/screen-capture"
    SCREEN_CAPTURE_SERVER = "http://#{`hostname`.strip}:8080/screen-capture"
    APP_ENV = YAML::load_file("#{ENV['WARDEN_CONFIG_DIR']}/app_env.yaml")["app_environment"]
    PAGE_OBJECTS = YAML::load_file("#{ENV['WARDEN_CONFIG_DIR']}/page_objects.yaml")["page_objects"]

    class << self

      CONFIG_OPTIONS = [
        :enable_test_case_registration,
        :screen_capture_dir, :screen_capture_server, :app_env,
        :page_objects, :debug_mode, :run_mode, :project_dir_name, :test_target_locale,
        :pkg_features_lib_path, :pkg_features_temp_path, :test_target_env,
        :test_target_name
      ]

      attr_accessor *CONFIG_OPTIONS

      def configure
        yield self
      end
    end

  end
end
