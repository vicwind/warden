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

  # Functions that need implementation to be a valid BuyingGuide page object
  
  # Tab interaction
  #needs_implementation :tab_one_exists, :tab_one_active
  #needs_implementation :tab_two_exists, :tab_two_active
  #needs_implementation :tab_three_exists, :tab_three_active
  #needs_implementation :tab_four_exists, :tab_four_active

  URL = "/"
  
  def initialize(page_session)
    @session = page_session
    setup_vars
  end

  def visit
    @session.visit URL
  end

  def setup_vars
  ########################################## 
  # Constant BG Objects                    #
  ########################################## 
  
    # These will be chosen based on their class identifiers
  
    # Header objects
    @start_link        = "a.start"
    @header_email_link = "a.email"
    @header_print_link = "a.print"
    
    # These will be chosen based on their css identifiers
    @keyword_field         = "#search_terms"
    @keyword_search_button = "img#keyword_search_go"
    
    # Footer Objects
    @legal_link = "a#legal"
    @ihi_link   = "img#ihi"
    
    @ru_ref_code_field  = "input#ref_code"
    @ru_ref_code_button = "img#ref_code_go" 
    
  ############################################# 
  # BG Client Objects                         #
  #                                           #
  # Copy and paste these into the setup_vars  #
  #   method and modify their values          #
  #############################################
  
    # Tab Variables
    # Example: 
    #  Bestbuy.ca tab_one corresponds to the "Find My New PC" for a new user
    #  Bestbuy.ca tab_two corresponds to the "Deal Zone" for a new user
    #  Bestbuy.ca tab_three corresponds to the "Top Rated" for a new user
    #  Bestbuy.ca tab_four corresponds to the "My Buying Guide" for a return user
    
    @tab_one        = "Change me"
    @tab_two        = "Change Me"
    @tab_three      = "Change Me"
    @tab_four       = "Change Me"

    # Tab One Objects
    # Example:
    # Bestbuy.ca tab_one_button_one corresponds to the Laptops button
    # Bestbuy.ca tab_one_button_two corresponds to the Desktops button
    # Bestbuy.ca tab_one_button_three corresponds to the Netbooks button
    
    @tab_one_button_one     = "Change Me"
    @tab_one_button_two     = "Change Me"
    @tab_one_button_three   = "Change Me"
    
    # tp_fp: Top Rated Featured Products
    @top_rated_featured_product_one   = "Change Me"
    @top_rated_featured_product_two   = "Change Me"
    @top_rated_featured_product_three = "Change Me"
    
    # dz_fp: Deal Zone Featured Products
    @dealzone_featured_product_one   = "Change Me"
    @dealzone_featured_product_two   = "Change Me"
    @dealzone_featured_product_three = "Change Me"
    @dealzone_all_deals_button       = "Change Me"
    
  ########################################## 
  # End of Vars to initialize              #
  ########################################## 
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

  def find_tab_one
    @session.find(@tab_one)
  end

  def tab_one_active?
   return @session.has_css?("#{@tab_one}.active")
  end
  
  def find_tab_two
    @session.find(@tab_one)
  end

  def tab_two_active?
   return @session.has_css?("#{@tab_two}.active")
  end

  def find_tab_three
    @session.find(@tab_one)
  end

  def tab_three_active?
   return @session.has_css?("#{@tab_three}.active")
  end

end