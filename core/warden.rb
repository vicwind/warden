module Warden
  require 'yaml'
  require 'capybara/cucumber'
  require 'ostruct' #provids dot access to hash value

  include Capybara::DSL
  
  SCREEN_CAPTURE_DIR = "#{ENV["WARDEN_HOME"]}/screen-capture"
  APP_ENV = YAML::load_file("#{ENV['WARDEN_CONFIG_DIR']}/app_env.yaml")["app_environment"]

  def load_config
      @app_domain =  APP_ENV["app_environment"][app_env]
  end

  def print_e
    puts @e
  end

  def set_e(val)
    @e = val
  end


  def current_project_name

  end

  def current_feature_name

  end

  def current_senario_name

  end

  def embed_screenshot(id, scenario)
    #%x(scrot #{$ROOT_PATH}/images/#{id}.png)
    project_name = ENV["WARDEN_TEST_TARGET_NAME"]
    image_capture_project_path = "#{SCREEN_CAPTURE_DIR}/#{project_name}"
    
    unless Dir.exist?( image_capture_project_path )
      Dir.mkdir( image_capture_project_path )
    end

    feature_name = @warden_session.feature_name()
    
    image_capture_file_name = "#{feature_name}-#{scenario.name.gsub(/[ \.'"\?]/,'_')}" + 
      "-#{Time.now.strftime("%m%d%Y_%H%M%S")}.jpg"
    file_path = "#{image_capture_project_path}/#{image_capture_file_name}"
    #puts "image file:" + file_path

    File.open(file_path,'wb') do |f|
      f.write(Base64.decode64(page.driver.browser.screenshot_as(:base64)))
    end
  end

  #used to store state during the cucumber feature execution
  class Warden_Session
    def initialize( cucumber_scenario )
      if cucumber_scenario.class == Cucumber::Ast::OutlineTable::ExampleRow #for senario outline
        @current_scenario = cucumber_scenario
        @current_scenario_outline = cucumber_scenario.scenario_outline
        @current_feature  = cucumber_scenario.scenario_outline.feature
      else
        @current_scenario = cucumber_scenario
        @current_feature  = cucumber_scenario.feature
      end
      #this line has to be ran after @current_feature has been set properly
      @current_featuer_data = load_current_feature_data()
    end

    attr_accessor :current_scenario, :current_feature

    def scenario_name
      #use secenario outline's name if the current senario
      #is a row in a example group
      @current_scenario_outline? @current_scenario_outline.name : @current_scenario.name
    end

    def feature_file_name
      @current_feature.file
    end

    def feature_name
      @current_feature.file.match(/\/([^\/]*)\.feature/)[1]
    end

    #Reads the feature data(test data) from an yaml file, which
    #has the file name of the feature file
    def load_current_feature_data
      feature_data = nil
      begin
        feature_data = YAML::load_file( feature_file_name().sub( /\.feature$/, ".yml" ) )
      rescue Errno::ENOENT => err
        #puts "Feature #{feature_file_name()} data file not found."
      end

      feature_data
    end

    #return the accorsponding senario in the feature data yml
    def feature_data
      if @current_featuer_data and @current_featuer_data[scenario_name()]
        @current_featuer_data[scenario_name()]
      else
        nil
      end
    end

  end

end
