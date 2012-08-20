module Warden
  require "#{ENV['WARDEN_CONFIG_DIR']}/config"

  require 'yaml'
  require 'capybara/cucumber'
  require 'ostruct' #provids dot access to hash value
  require 'i18n'
  require 'test_case_manager'

  include Capybara::DSL
  include Config

  ILLEGALC = /[^\w `#`~!@''\$%&\(\)_\-\+=\[\]\{\};,\.]/ #used to sanitize the file name

  class << self
    def step_detail
      @step_detail ||= []
    end

    def add_step_detail(msg)
      step_detail().push(msg)
    end

    def clear_step_detail()
      @step_detail = []
    end

    def test_target_detail
      @test_target_detail ||= []
    end

    def add_test_target_detail(msg)
      test_target_detail().push(msg)
    end

    def clear_test_target_detail
      @test_target_detail = []
    end

    def test_case_manager
      YAMLStoreTestCaseManager.create_new_test_case_map unless
        File.exists? YAMLStoreTestCaseManager.test_case_map_path
      @test_case_manager ||= YAMLStoreTestCaseManager.new()
    end
  end #of defineing metaclass

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
    Config::test_target_name
  end

  def current_feature_name

  end

  def current_senario_name

  end

  #uses capybara's page driver to do screen capturing
  def embed_screenshot( image_capture_file_name )
    #%x(scrot #{$ROOT_PATH}/images/#{id}.png)
    project_name = Config::test_target_name
    image_capture_project_path = "#{Config::SCREEN_CAPTURE_DIR}/#{project_name}"

    unless Dir.exist?( image_capture_project_path )
      Dir.mkdir( image_capture_project_path )
    end

    image_capture_file_name.gsub!(ILLEGALC, '_')
    file_path = "#{image_capture_project_path}/#{image_capture_file_name}"

    File.open(file_path,'wb') do |f|
      f.write(Base64.decode64(page.driver.browser.screenshot_as(:base64)))
    end
  end

  #Provide a convenient way to call the translation method
  #a @warden_session is in the binding class needed in order for this methods to work
  def _t(*args)
    @warden_session.translate(*args)
  end

  #####################
  ##Warden class method
  #####################
  #
  #It will return the project path base on ENV['WARDEN_PROJECT_PATH'] if it exists,
  #otherwise it will return the project path base on Warden::Config::test_target_name
  #return the absolute path to the current project
  def self.project_path
    project_path = "#{Warden::projects_root_path()}/#{ENV['WARDEN_PROJECT_DIR_NAME']}"
    if ENV["WARDEN_PROJECT_DIR_NAME"] and Dir.exists? project_path
      ENV["WARDEN_PROJECT_DIR_NAME"]
    else
      "#{Warden::projects_root_path()}/#{Warden::Config::test_target_name}"
    end
  end

  #return the root path of the projects directory
  def self.projects_root_path
    "#{ENV['WARDEN_HOME']}/projects"
  end


  #####################
  ##
  ## Warden_Session Class
  ##
  #####################
  #used to store state during the cucumber feature execution
  class Warden_Session
    include Warden
    include Config

    #the key is the scenario, the value is an array of screen capture URL or fiel path
    @@scenario_screen_capture = {}

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

      #load the pkg's locale dictionary yaml if the projct uses a pkg features and there is a
      #./etc/locale.yml file
      add_i18n_dictionary(Warden::Config::pkg_features_temp_path +
                          "/etc/locale.yml") if Warden::Config::pkg_features_temp_path
      #load the locale dictionary from yaml
      @project_local_path = project_path() + "/etc/locale.yml"
      add_i18n_dictionary(@project_local_path)

      set_locale(Config::test_target_locale) if Config::test_target_locale

      #register the scenario to test case manager
      if Warden::Config::ENABLE_TEST_CASE_REGISTRATION
        Warden.test_case_manager.
          register_scenario(current_project_name, @current_scenario)
      end

      @extra_log = [] #this array will store additional log message, and it will print out at the end of each senario
    end

    attr_accessor :current_scenario, :current_feature, :external_data, :extra_log


    def scenario_name
      #use secenario outline's name if the current senario
      #is a row in a example group
      @current_scenario_outline? @current_scenario_outline.name : @current_scenario.name
    end

    def feature_file_name
      @current_feature.file
    end

    def feature_name
      # result = @current_feature.file.split('/')[-1]
      # if result #file path name that contains "/"
        # return result[-1]
      # else
        # #contains only the file name
        # return @current_feature.file
      # end
      @current_feature.file.split('/')[-1].split('.')[0]
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

    #parameter:
    #  prefix: this string will be used as prefix of the file name
    #  scenario: the cucumber scenario object
    #
    #Return: the file name of the image capture
    def capture_screen_shot_base( scenario,  prefix = '' )

      feature_name = feature_name()

      image_capture_file_name = "#{feature_name}-#{scenario.name.gsub(/[ \.'"\?]/,'_')}" + 
      "-#{Time.now.strftime("%m%d%Y_%H%M%S")}.jpg"
      image_capture_file_name = ( prefix != '' )? prefix + "-" +
        image_capture_file_name : image_capture_file_name
      type = (scenario.failed?)? '[Failure]' : '[Normal]'

      embed_screenshot( image_capture_file_name )
      screen_capture_base_path = Warden::Config::run_mode == "server" ?  SCREEN_CAPTURE_SERVER : SCREEN_CAPTURE_DIR
      screen_capture_url = "#{type} screen capture is at: " + screen_capture_base_path + '/' + Config::test_target_name + '/' +
        image_capture_file_name
      #print FORMATS[:failed].call(screen_capture_url) if scenario.failed? 

      scneario_outline = scenario.scenario_outline if scenario.kind_of? Cucumber::Ast::OutlineTable::ExampleRow

      if @@scenario_screen_capture.has_key?(scenario)
        @@scenario_screen_capture[scenario].push(screen_capture_url)
      else
        @@scenario_screen_capture[scenario] = []
        @@scenario_screen_capture[scenario].push(screen_capture_url)
      end
      #also store the screen capture under a scneario outline
      #because 'print_screen_capture_url' will only passed in scneario_ouline object not
      #the example row obejct
      @@scenario_screen_capture[scneario_outline] = [] unless @@scenario_screen_capture.has_key?(scneario_outline)
      @@scenario_screen_capture[scneario_outline].push(screen_capture_url) if scneario_outline
      image_capture_file_name
    end

    #users should uses this methods to capture screen shot in the step definition
    ##parameter:
    #  prefix: this string will be used as prefix of the file name
    ##Return: the file name of the image capture
    def capture_screen_shot( prefix = '')
      capture_screen_shot_base( @current_scenario , prefix )
    end

    #I18n support for translating text. it uses the current feature name to
    #and key/string to help locate the correct translation in the locale yml file
    #support for all the argument of the original I18n.translate method
    #Return: the translated string
    def translate(*args)
      scope = feature_name().split('.')[0]
      options = args.last.is_a?(Hash) ? args.pop : {}
      look_up_name = args.shift.to_s
      if is_global = look_up_name.match(/^\$(.*)/)
        scope = '_GLOBAL_'
        look_up_name = is_global[1] #get the string after the "$"
      end

      I18n.translate("#{scope}.#{look_up_name.to_s}", options)
    end


    #set the locale of I18n translation
    def set_locale(locale)
      I18n.locale = locale
    end

    #Add to the i18n load path only when the files exists and its not already int the path
    #Return: None
    def add_i18n_dictionary(yml_path)
      I18n.load_path << yml_path if !I18n.load_path.include? yml_path and
        File.exists?(yml_path)
    end

    #call Warden's project_path class methods
    def project_path
      Warden::project_path()
    end

    #return an array of screen capture links hash
    def get_screen_capture_links(scenario)
      links_text = self.class.get_scenario_screen_capture[scenario]
      if links_text
        links_data = links_text.inject([]) do |links, link_text|
          status_type = link_text.match(/^\[Normal\]/) ? 'normal' : 'error'
          url = link_text.match(/at: (.*)/)[1]
          links << { :status_type => status_type, :url => url }
        end
      end
      links_data
    end

    def puts_extra_log(log_msg)
      @extra_log.push("#{Time.now} [log]: #{log_msg}")
    end

    ########################
    ##
    ## Class Methods
    ##
    ########################

    #return a hash of :scenario => screen capthre path array
    def self.get_scenario_screen_capture
      @@scenario_screen_capture
    end

  end #end of warden_session class

end
