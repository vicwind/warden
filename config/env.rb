#require 'capybara/cucumber'
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../core"
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../config"

require 'sauce'
require 'ruby-debug'

require "#{File.dirname(__FILE__)}/../config/config"
require "#{File.dirname(__FILE__)}/../core/warden"
require "#{File.dirname(__FILE__)}/../lib/lib_steps"
require "#{File.dirname(__FILE__)}/../lib/link_checker"
require "#{File.dirname(__FILE__)}/../lib/price_rogue"
require "#{File.dirname(__FILE__)}/../lib/page_objects"
require "#{File.dirname(__FILE__)}/../lib/gerbil"
require "#{File.dirname(__FILE__)}/../lib/cucumber_formatter"
require "#{File.dirname(__FILE__)}/../lib/warden_web_formatter"
require "#{File.dirname(__FILE__)}/../config/sauce_connect_config"
World(Warden)

#require './selenium_remote'
#Capybara.app = "Google"
# module Capybara
  # include Warden
# end
Debugger.settings[:autoeval] = true
Debugger.settings[:autolist] = 10

# Cleanup log folder before run, this needs to be more
# sophisticated.
FileUtils.rm Dir.glob("#{ENV["WARDEN_HOME"]}log/*.yaml")

# Capybara.register_driver :chrome do |app|
#   Capybara::Selenium::Driver.new(app, :browser => :chrome)
# end

#Capybara.javascript_driver = :chrome

Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :selenium
  config.default_wait_time = 20 #for ajax heavy site, site it to a higher number
end

require 'sauce/capybara'

Sauce.config do |config|
  config.username = ""
  config.access_key = ""
  config.browser = "firefox"
  config.os = "Windows 2003"
  config.browser_version = "7"
end

Before do |scenario|
  #browser.open()
  @warden_session = Warden::Warden_Session.new(scenario)
  #make feature data avaiable in steps
  @fd = OpenStruct.new( @warden_session.feature_data() )
end

if ENV['TC_RUN_INFO_IDS'] and !ENV['TC_RUN_INFO_IDS'].empty?
  require 'warden_web_interface'

  #Note: the order of this array is important, as it will be used to
  #  update the test case run info record in Warden Web
  test_case_run_info_id_list = ENV['TC_RUN_INFO_IDS'].split(',')
  current_tc_run_info_id = nil

  Before do |scenario|
    if current_tc_run_info_id = test_case_run_info_id_list.delete_at(0)
      WardenWebInterface.update_test_case_run_info(current_tc_run_info_id, {
        :start_at => Time.now,
        :status => "Running"
      })
    end
  end

  After do |scenario|
    if current_tc_run_info_id
      status = (scenario.failed?)? "Failed" : "Passed"
      exeception_msg = ''
      screen_capture_links = @warden_session.get_screen_capture_links(scenario)

      if scenario.failed?
        exeception_msg = "\n\n" + scenario.exception.message + "\n"
        exeception_msg += scenario.exception.backtrace.join("\n")
      end

      #current_scenario_log = WardenWebInterface.read_log_from_buffer + exeception_msg #differnet way to getting cucumber log
      current_scenario_log = "#{WardenWebInterface::log_io.print_io_content}\n #{exeception_msg}"

      tc_run_info = {
        :status => status,
        :test_case_log => current_scenario_log,
        :screen_capture_links => screen_capture_links.to_json
      }
      tc_run_info.merge!(external_data: @warden_session.external_data.to_json) if @warden_session.external_data

      WardenWebInterface.update_test_case_run_info(current_tc_run_info_id, tc_run_info)
      # WardenWebInterface.
      #   update_test_case_run_info_status(current_tc_run_info_id, status)
      # current_scenario_log = WardenWebInterface.read_log_from_buffer + exeception_msg
      # WardenWebInterface.
      #   update_test_case_run_info_log(current_tc_run_info_id, current_scenario_log)
    end
  end
end

After do |scenario|
  begin
    @warden_session.capture_screen_shot()# if scenario.failed?

    if scenario.failed? and Warden::Config::debug_mode
      print "\nYou are in ruby debug mode.\n"
      print scenario.exception.message + "\n"
      print scenario.exception.backtrace.join("\n")
      print "\n\n"
      Debugger.start do
        debugger
        puts "OK."
      end
    end
  rescue Exception => e
    #display any exception in the After block, otherwise it will be captured
    #sinked by Cucumber
    print "\n"
    print "Exception happened inside the After hook:"
    print e.message
    print e.backtrace[0..10].join("\n")
    raise e
  end
end

#setup configuration hook for loading feature and steps pkg from a different location
AfterConfiguration do |config|
  if Warden::Config::pkg_features_lib_path and Warden::Config::pkg_features_lib_path != ''
    require "#{File.dirname(__FILE__)}/../lib/cucumber_patch"
    pkg_manager = Gerbil.new()
    tmp_pkg_path = pkg_manager.gerbilnate(Warden::Config::pkg_features_lib_path,
                                          Warden::project_path())
    Warden::Config::pkg_features_temp_path = tmp_pkg_path #temporary path Gerbil extracted
                                                      #the files to
    config.pkg_step_and_lib_files(tmp_pkg_path)
    puts config.get_pkg_setup_info()
  end
end



at_exit do
  # puts "-------------------------------"
  # puts WardenWebInterface.read_log_from_buffer
  # puts WardenWebInterface.read_log_from_buffer
  # puts Warden.test_case_manager().find_all_features_by_project('BB.ca Web BG').to_yaml
  # puts Warden.test_case_manager().find_all_scenarios_by_feature('BB.ca Web BG',
  #
  #puts  Warden.test_case_manager().tc_id_to_run_path(24)
  #puts  Warden.test_case_manager().tc_id_to_run_path(1)
end
# AfterStep do |scenario|

# end

