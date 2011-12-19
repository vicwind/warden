#require 'capybara/cucumber'
require 'sauce'
require 'ruby-debug'
require "#{File.dirname(__FILE__)}/../lib/lib_steps"
require "#{File.dirname(__FILE__)}/../core/warden"

World(Warden)

#require './selenium_remote'
#Capybara.app = "Google"
# module Capybara
  # include Warden
# end

Capybara.configure do |config|
  config.run_server = false
  config.app_host = Warden::APP_ENV["prd"]["BB.ca Web BG"]
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
  #debugger
  #browser.open()
  @warden_session = Warden::Warden_Session.new(scenario)
  #@warden_session.current_scenario = 

end

After do |scenario|
  embed_screenshot("screenshot-#{Time.new.to_i}", scenario) # if scenario.failed?
end
