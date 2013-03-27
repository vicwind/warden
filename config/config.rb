require 'active_support/core_ext/hash'

module Warden
  module Config

    #Uses test case manager to register scenarios
    ENABLE_TEST_CASE_REGISTRATION = true

    WEB_BASE_URL = "http://localhost:3000"

    SCREEN_CAPTURE_DIR = "#{ENV["WARDEN_HOME"]}/screen-capture"
    SCREEN_CAPTURE_SERVER = "http://#{`hostname`.strip}:8080/screen-capture"
    PAGE_OBJECTS = YAML::load_file("#{ENV['WARDEN_CONFIG_DIR']}/page_objects.yaml")["page_objects"]

    DEFAULT_GLOBAL_CONFIG = {
      run_mode:  "local"
    }

    class << self

      CONFIG_OPTIONS = [
        :enable_test_case_registration,
        :screen_capture_dir, :screen_capture_server, :app_env,
        :page_objects, :debug_mode, :run_mode, :project_dir_name, :test_target_locale,
        :pkg_features_lib_path, :pkg_features_temp_path, :test_target_env,
        :test_target_name, :app_env, :http_proxy_setting
      ]

      attr_accessor *CONFIG_OPTIONS

      def configure
        #setting default global config
        self.run_mode = DEFAULT_GLOBAL_CONFIG[:run_mode]

        yield self
      end

      #this method will load the default app_env.yaml file and merge it with the project
      #level app_env.yaml, and the project level configuration will take precedence
      def app_env
        return @app_env if @app_env

        global_app_env = YAML::load_file("#{ENV['WARDEN_CONFIG_DIR']}/app_env.yaml")
        project_app_env_file_path = "#{Warden::project_path}/etc/app_env.yaml"

        if File.exists?(project_app_env_file_path)
          project_app_env = YAML::load_file("#{Warden::project_path}/etc/app_env.yaml")
          global_app_env.deep_merge!(project_app_env)
        end

        @app_env = global_app_env['app_environment']
      end

      #enable the underlining driver to use proxy server for communication
      #params:
      #  proxy_server: the proxy server name or ip
      #  port: the proxy server's port
      #  user_name: user name
      #  password: password of the user name
      def setup_proxy(proxy_server, port, user_name = nil, password = nil)
        self.http_proxy_setting = {
          http: {
            server: proxy_server,
            port: port
          }
        }
        if user_name and password
          self.http_proxy_setting[:http][:user_name] = user_name
          self.http_proxy_setting[:http][:password] = password
        end
      end
    end #of class method


  end


end
