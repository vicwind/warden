require 'cucumber/formatter/pretty'
require 'cucumber/formatter/console'
module CucumberFormatter
  class Debug < Cucumber::Formatter::Pretty

    # def initialize(step_mother, io, options)
      # # We don't care about these - we're just twittering!
    # end

    alias_method :original_after_table_row, :after_table_row
    alias_method :original_before_table_row, :before_table_row

    def before_step(step)
      Warden.clear_step_detail()
    end

    def after_step(step) 
      Warden.step_detail().each do |detail|
        @io.puts format_string(format_msg(detail), :tag).indent(6)
      end
    end

    def before_table_row(table_row)
      Warden.clear_step_detail()
      original_before_table_row(table_row)
    end

    def after_table_row(table_row)
      @io.puts 
      Warden.step_detail().each do |detail|
        @io.puts format_string(format_msg(detail), :tag).indent(8) if detail
      end
      original_after_table_row(table_row)
    end

    #format the messag with date time and other system related data
    #return: a formated msg
    def format_msg(msg)
      "#{Time.now} [action]: " + msg
    end

    #####################
    ##  Max-in Capybara
    ##
    ##  Provide more verbose debug message by displaying all the actions of the capybara node
    ##  in the console/log 
    #####################

    module Capybara::Node::Actions
      alias_method :original_fill_in, :fill_in
      alias_method :original_check, :check
      alias_method :original_choose, :choose
      alias_method :original_click_button, :click_button
      alias_method :original_click_link, :click_link
      alias_method :original_click_link_or_button, :click_link_or_button
      alias_method :original_select, :select
      alias_method :orginal_uncheck, :uncheck
      alias_method :orginal_unselect, :unselect

      def fill_in(locator, options = {})
        step_detail = "Fill in locator '#{locator}' with option '#{options.inspect()}'"
        Warden.add_step_detail(step_detail)
        original_fill_in(locator, options)
      end

      def check(locator)
        step_detail = "Check checkbox at '#{locator}'"
        Warden.add_step_detail(step_detail)
        original_check(locator)
      end

      def choose(locator)
        step_detail = "Choose a radio button at '#{locator}'"
        Warden.add_step_detail(step_detail)
        original_choose(locator)
      end

      def click_button(locator)
        step_detail = "Click button at '#{locator}'"
        Warden.add_step_detail(step_detail)
        original_click_button(locator)
      end

      def click_link(locator)
        step_detail = "Click link at '#{locator}'"
        Warden.add_step_detail(step_detail)
        original_click_link(locator)
      end

      def click_link_or_button(locator)
        step_detail = "Click link or button at '#{locator}'"
        Warden.add_step_detail(step_detail)
        original_click_link_or_button(locator)
      end

      def select(value, option={})
        step_detail = "Select option with value '#{value}' by '#{option.inspect}'"
        Warden.add_step_detail(step_detail)
        original_select(value, option)
      end

      def uncheck(locator)
        step_detail = "Uncheck checkbox at '#{locator}'"
        Warden.add_step_detail(step_detail)
        original_uncheck(locator)
      end

      def unselect(value, option={})
        step_detail = "Unselect option with value '#{value}' by '#{option.inspect}'"
        Warden.add_step_detail(step_detail)
        original_unselect(value, option)
      end

    end #end of Capybara::Node::Actions moudle

    class Capybara::Node::Element 
      alias_method :original_click, :click
      alias_method :original_set, :set

      def click()
        characteristic_type, characteristic_value = get_element_characteristic()

        step_detail = "Click at element '#{tag_name}' with " + 
          "#{characteristic_type}=#{characteristic_value} "
        Warden.add_step_detail(step_detail)
        original_click()
      end

      #get the element's charateristic like its id, name or text
      #return the type and value when there is a charateristics that's
      # not null or empty
      #return: [characteristic_type, characteristic_value]
      def get_element_characteristic()
        characteristic_type = ''
        characteristic_value = ''

        [:id, :name, :value].each do |identity|
          if self[identity] && self[identity] != ''
            characteristic_type = identity
            characteristic_value = self[identity]
            break
          end
        end
        if characteristic_type == ''
          characteristic_type = 'text'
          characteristic_value = text()
        end
        [characteristic_type, characteristic_value]
      end

      def set(value)
        characteristic_type, characteristic_value = get_element_characteristic()
        step_detail = "Set value '#{value}' for  element '#{tag_name}' with " + 
          "#{characteristic_type}=#{characteristic_value} "
        Warden.add_step_detail(step_detail)
        original_set(value)
      end
    end #of class Capybara::Node::Element 

  end #of class Debug

end #of module CucumberFormatter


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
    screen_captures = Warden::Warden_Session.get_scenario_screen_capture()
    screen_captures[scenario].each do |screen_capture|
      @io.puts format_string( "  " + screen_capture, :failed) 
    end
  end
end #of Cucumber::Formatter::Console
