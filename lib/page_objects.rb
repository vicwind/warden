##########################################################
# Page Objects                                           #
#                                                        #
# Purpose:  This file is used to keep the env.rb file    #
#           clean from too many require statments.       #
#           Below you will find the files that make up   #
#           a valid page object. 
#                                                        #
##########################################################


#########################################
#  Do NOT modify these                  #
#########################################

  ##########################
  # Buying Guide Tab files #
  ##########################
  
  require "#{File.dirname(__FILE__)}/page_objects/tabs/find_my_new_tab"
  require "#{File.dirname(__FILE__)}/page_objects/tabs/deal_zone_tab"
  require "#{File.dirname(__FILE__)}/page_objects/tabs/top_rated_tab"
  require "#{File.dirname(__FILE__)}/page_objects/tabs/my_buying_guide_tab"
  require "#{File.dirname(__FILE__)}/page_objects/tabs/tab_interactions"

  #############################
  # Buying Guide Capabilities #
  #############################
  
  require "#{File.dirname(__FILE__)}/page_objects/features/bg_compare"  
  require "#{File.dirname(__FILE__)}/page_objects/features/bg_favorites"
  require "#{File.dirname(__FILE__)}/page_objects/features/bg_results"
  require "#{File.dirname(__FILE__)}/page_objects/features/bg_search"
  
  #########################################
  # Buying Guide required files           #
  #########################################

  require "#{File.dirname(__FILE__)}/page_objects/buying_guide_interface"
  require "#{File.dirname(__FILE__)}/page_objects/buying_guide_mobile_interface"
  require "#{File.dirname(__FILE__)}/page_objects/buying_guide_page"  
  require "#{File.dirname(__FILE__)}/page_objects/buying_guide_mobile_page"  

#########################################
#  Include custom instances             # 
#  here.                                #
#########################################

  #########################################
  # Buying Guide instanace files          #
  #########################################
  
  Dir["#{File.dirname(__FILE__)}/page_objects/instances/*.rb"].each {|file| require file }
