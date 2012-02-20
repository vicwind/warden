######################################################
## Check out https://github.com/saucelabs/sauce_ruby
## for more detail about config option and usage
######################################################

require 'sauce'
require 'sauce/capybara'

#this needs to require after "sauce/capybara" to provide a enhenced version of Sauce Connect
require "#{File.dirname(__FILE__)}/../lib/sauce_connect_patch"

Sauce.config do |config|
  config.enable_tunneling = false #turn on only when testing local site or sites
                                  #behine a firewall
  config.username = ""
  config.access_key = ""
  config.browser = "firefox"
  config.os = "Windows 2003"
  config.browser_version = "8"
end
