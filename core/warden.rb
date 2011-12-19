module Warden
  require 'yaml'
  require 'capybara/cucumber'
  include Capybara::DSL
  
  SCREEN_CAPTURE_DIR = "#{ENV["WARDEN_HOME"]}/screen-capture"
  APP_ENV = YAML.load_file("#{ENV['WARDEN_CONFIG_DIR']}/app_env.yaml")["app_environment"]
  def load_config
      @app_domain =  APP_ENV["app_environment"][app_env]
  end

  def print_e
    puts @e
  end

  def set_e(val)
    @e = val
  end

  def self.test_123()
    puts "=============================="
  end

  def current_project_name

  end

  def current_feature_name

  end

  def current_senario_name

  end

  def embed_screenshot(id,scenario)
    #%x(scrot #{$ROOT_PATH}/images/#{id}.png)
    file_path = "#{SCREEN_CAPTURE_DIR}/#{scenario.name.gsub(/ /,'_')}-#{Time.now.strftime("%m%d%Y_%H%M%S")}.jpg"
    #puts "image file:" + file_path

    File.open(file_path,'wb') do |f|
      f.write(Base64.decode64(page.driver.browser.screenshot_as(:base64)))
    end
  end

  #used to store state duringthe cucumber feature execution
  class Warden_Session
    def initialize( cucumber_scenario )
      @current_scenario = cucumber_scenario
      @current_feature  = cucumber_scenario.feature
    end
    attr_accessor :current_scenario, :current_feature

    def scenario_name
      @cucumber_scenario.name
    end

    def feature_name
      @current_feature.file
    end
  end

end
