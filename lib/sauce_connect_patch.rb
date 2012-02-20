require 'capybara'
require 'uri'

############################################################
## This class Mix-in is intended to over-write the one's
## implemented in the sauce gem to provide more flexisble
## uses of Sacue Connect and changing of app_host later on
## in different cucumber senario
##
#############################################################

module Sauce
  module Capybara
    class Driver < ::Capybara::Selenium::Driver
      def browser
        unless @browser
          puts "[Connecting to Sauce OnDemand (path file: sauce_connect_patch.rb)...]"
          config = Sauce::Config.new
          @enable_tunneling = config.opts[:enable_tunneling] || false

          if @enable_tunneling
            @domain = "#{rand(10000)}.test"
            puts "Activating Sauce Connect Tunnel..."
            capybara_app_host_uri = URI.parse(rack_server.url("/")) #take care of app_host and rack_server cases
            @sauce_tunnel = Sauce::Connect.new(:host => rack_server.host,
                                               :port => capybara_app_host_uri.port,
                                               :domain => @domain,
                                               :quiet => true)
            @sauce_tunnel.wait_until_ready
          else
            capybara_app_host_uri = URI.parse(url('/')) #be able to access the real Capybara module's app_host
            @domain = capybara_app_host_uri.host
          end

          @browser = Sauce::Selenium2.new(:name => "Capybara test",
                                          :browser_url => "http://#{@domain}")
          puts "Job URL: https://saucelabs.com/jobs/#{@browser.session_id}"
          at_exit do
            @browser.quit
            @sauce_tunnel.disconnect if @enable_tunneling
          end
        end
        @browser
      end

      private

      def url(path)
        if @enable_tunneling
          if path =~ /^http/
            path
          else
            "http://#{@domain}#{path}"
          end
        else
          super(path)
        end
      end
    end
  end
end
