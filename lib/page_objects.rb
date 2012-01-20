# This is just a helper file so that the env.rb doesn't get cluttered with require statements
# TODO: This should be more dynamic and only load the necessariy page objects depending upon the project

require "#{File.dirname(__FILE__)}/page_objects/buying_guide_interface"
require "#{File.dirname(__FILE__)}/page_objects/buying_guide_page"
require "#{File.dirname(__FILE__)}/page_objects/best_buy_canada_page"