require 'cucumber/formatter/pretty'
require 'cucumber/formatter/console'
module CucumberFormatter
  class Full_Debug < Cucumber::Formatter::Pretty
    # def initialize(step_mother, io, options)
      # # We don't care about these - we're just twittering!
    # end

    def after_step(step) 
      #debugger
      @io.printf "... #{step.name}\n"
      @io.flush
      print_message("Somethign to test") 
    end
  end


end

#####################################################
## Mix-in 
##
## Reopen the cucumber console module to over write methods to support add-on features
#####################################################
module Cucumber::Formatter::Console
  def print_stats(features, options)
    @failures = step_mother.scenarios(:failed).select { |s| s.is_a?(Cucumber::Ast::Scenario) || s.is_a?(Cucumber::Ast::OutlineTable::ExampleRow) }
    @failures.collect! { |s| (s.is_a?(Cucumber::Ast::OutlineTable::ExampleRow)) ? s.scenario_outline : s }

    if !@failures.empty?          
      @io.puts format_string("Failing Scenarios:", :failed)
      @failures.each do |failure|
        profiles_string = options.custom_profiles.empty? ? '' : (options.custom_profiles.map{|profile| "-p #{profile}" }).join(' ') + ' '
        source = options[:source] ? format_string(" # Scenario: " + failure.name, :comment) : ''
        @io.puts format_string("cucumber #{profiles_string}" + failure.file_colon_line, :failed) + source
        print_screen_capture_url(failure) #this is the only line that's added
      end
      @io.puts
    end

    @io.puts scenario_summary(step_mother) {|status_count, status| format_string(status_count, status)}
    @io.puts step_summary(step_mother) {|status_count, status| format_string(status_count, status)}

    @io.puts(format_duration(features.duration)) if features && features.duration

    @io.flush
  end

  #print all of the screen captures url for the scenario
  def print_screen_capture_url(scenario)
    screen_captures = Warden::Warden_Session.get_fail_scenario_capture()
    screen_captures[scenario].each do |screen_capture|
      @io.puts format_string( "  " + screen_capture, :failed) 
    end
  end
end
