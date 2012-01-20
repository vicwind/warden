################################################################################################
##  Buying Guide Page Object                                                                   #
################################################################################################
##  Purpose: 
##           The purpose of this class is to provide access to objects and create an abstract
##           way of interacting with a page that's built using the Buying Guide platform.
##
##  Use: 
##           For proper use, this class should be extended in a separate client page object.
##           Common tasks will be stored in this object, but the purpose is to override these
##           method calls when differences in client websites turn up. 
##
##  Requirements:
##           When extending this class, the user is required to initialize a list of global object
##           to correspond to the client page. The list of global objects to fill values for are
##           found in the BG Client Objects section of this class. The purpose of this is to force 
##           the user to modify values per client page and help with debugging.
##
##  If you have questions please contact ray@ironhorseinteractive.com
#################################################################################################

class BuyingGuidePage
  include BuyingGuideInterface

  URL = "/"
  
  def initialize(page_session)
    @session = page_session
  end

  def visit
    query_session_elements    
    @session.visit URL
  end

 ########################################## 
 # Link capabilities of the BG platform   #
 ########################################## 
  
  # Links Exist
  def find_legal_link
    @session.find( @legal_link )
  end
  
  def find_start_link
    @session.find( @start_link )
  end
  
  def find_email_link
    @session.find( @header_email_link )
  end
  
  def find_ihi_link
    @session.find( @ihi_link )
  end
  
  # Link Clicks
  def click_start_link
   link = @session.find( @start_link )
   link.click
  end
  
  def click_header_email_link
   link = @session.find( @header_email_link )
   link.click
  end
  
  def click_legal_link
   link = @session.find( @legal_link )
   link.click
  end
  
  def click_ihi_link
   link = @session.find( @ihi_link )
   link.click
  end

########################################## 
# Search capabilities of the BG platform #
########################################## 
 def find_search_field
    @session.find( @keyword_field )
 end
 
 ##################
 # Keyword Search #
 ##################
 
 # User enters keyword search parameters
 def enter_keywords( input )
   @session.fill_in( @keyword_field,:with => input )
 end  
   
 # User clicks keyword search button
 def click_keyword_search()
   @session.find( @keyword_search_button ).click
 end
 
 ##################
 # Refcode search #
 ##################
 
 # User enters reference code
 def enter_reference_code( input )
    @session.fill_in( @ru_ref_code_field,:with => input )
 end  
 
 # User clicks reference code search button
 def click_reference_code_search
   @session.find( @ru_ref_code_button ).click
 end

############################################# 
# Favorites capabilities of the BG platform #
############################################# 

  # User expands Favorites section

################################################# 
# Recent Search capabilities of the BG platform #
#################################################

  # User expands Recent Searches section

################################################# 
# Tab Interaction                               #
#################################################


  ##########################
  # Find My New Tab        #
  ##########################
  def find_find_my_new_tab
    @session.find(@find_my_new_tab)
  end

  def find_my_new_tab_active?
   return @session.has_css?("#{@find_my_new_tab}.active")
  end

  def click_find_my_new_tab
    @session.find(@find_my_new_tab).click
  end
      
  ########################## 
  # Dealzone Tab           #
  ##########################
  def find_deal_zone_tab
    @session.find(@deal_zone_tab)
  end

  def deal_zone_tab_active?
   return @session.has_css?("#{@deal_zone_tab}.active")
  end

  def click_deal_zone_tab
    @session.find(@deal_zone_tab).click
  end

  def find_dealzone_all_deals_button
    @session.find_button(@dealzone_all_deals_button)
  end

  def click_dealzone_all_deals_button
    @session.find_button(@dealzone_all_deals_button).click
  end

  ##########################
  # Top Rated Tab          #
  ##########################
  def find_top_rated_tab
    @session.find(@top_rated_tab)
  end

  def top_rated_tab_active?
   return @session.has_css?("#{@top_rated_tab}.active")
  end

  def click_top_rated_tab
    @session.find(@top_rated_tab).click
  end

  ##########################
  # My Buying Guide Tab    #
  ##########################
  def find_my_buying_guide_tab
    @session.find(@my_buying_guide_tab)
  end

  def my_buying_guide_tab_active?
   return @session.has_css?("#{@my_buying_guide_tab}.active")
  end
  
  def click_my_buying_guide
    @session.find(@my_buying_guide).click
  end
  
end