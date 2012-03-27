#require 'capybara/cucumber'
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../core"
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"

require 'sauce'
require 'ruby-debug'

require "#{File.dirname(__FILE__)}/../core/warden"
require "#{File.dirname(__FILE__)}/../lib/lib_steps"
require "#{File.dirname(__FILE__)}/../lib/link_checker"
require "#{File.dirname(__FILE__)}/../lib/price_rogue"
require "#{File.dirname(__FILE__)}/../lib/page_objects"
require "#{File.dirname(__FILE__)}/../lib/gerbil"
require "#{File.dirname(__FILE__)}/../config/sauce_connect_config"
World(Warden)

#require './selenium_remote'
#Capybara.app = "Google"
# module Capybara
  # include Warden
# end
Debugger.settings[:autoeval] = true
Debugger.settings[:autolist] = 0

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
  config.default_wait_time = 30 #for ajax heavy site, site it to a higher number
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

After do |scenario|
  begin
    @warden_session.capture_screen_shot()# if scenario.failed?

    if scenario.failed? and ENV["WARDEN_DEBUG_MODE"] == "true"
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
  if ENV["WARDEN_PKG_FEATURES_LIB_PATH"] and ENV["WARDEN_PKG_FEATURES_LIB_PATH"] != ''
    require "#{File.dirname(__FILE__)}/../lib/cucumber_patch"
    pkg_manager = Gerbil.new()
    tmp_pkg_path = pkg_manager.gerbilnate(ENV["WARDEN_PKG_FEATURES_LIB_PATH"],
                                          Warden::project_path())
    ENV['WARDEN_PKG_FEATURES_TEMP_PATH'] = tmp_pkg_path #temporary path Gerbil extracted
                                                      #the files to
    config.pkg_step_and_lib_files(tmp_pkg_path)
    puts config.get_pkg_setup_info()
  end
end

at_exit do
  # puts Warden.test_case_manager().find_all_features_by_project('BB.ca Web BG').to_yaml
  # puts Warden.test_case_manager().find_all_scenarios_by_feature('BB.ca Web BG',
  #
  #puts  Warden.test_case_manager().tc_id_to_run_path(24)
  #puts  Warden.test_case_manager().tc_id_to_run_path(1)
end

# AfterStep do |scenario|

# end

