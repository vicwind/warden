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

  attr_accessor :session
  
  include BuyingGuideInterface

  ################################################# 
  # Tabs                                          #
  #################################################
    include FindMyNewTab
    include DealZoneTab
    include TopRatedTab
    include MyBuyingGuideTab     
    include TabInteractions
    
  ################################################# 
  # Features                                      #
  #################################################
    include BGSearch
    include BGCompare
    include BGFavorites
    include BGResults

  URL = "/"
  
  def initialize(page_session)
    @session = page_session
    
    #Link Checking helper class
    @link_checker = LinkChecker.new
  end

  def visit
    query_session_elements    
    @session.visit URL
  end

  def click_close_button
    close_button = @session.find(:css,"div.close")
    close_button.click
  end

 ########################################## 
 # Universal Links                        #
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
  
############################################# 
# Universal Buttons                         #
############################################# 

  def find_start_new_search_on_my_buying_guide_page
    @session.find(:css,"#start_new_search")
  end

  def click_start_new_search_on_my_buying_guide
    @session.find(:css,"#start_new_search").click
  end

  def click_go_to_results
    wait_for_loading
    @session.find(:css,"button.question_nav.go_to_results").click
  end

  def click_start_new_search_from_buying_guide
    @session.find(:css,".start_new_search").click
  end

  def find_back_button
    @session.find(:css,".back.generic_nav")
  end
  
  def find_product_details_button
    @session.find(:css,".feature.product .view_details")
  end
  
  def wait_for_loading
    loader = @session.find(:css,"#loader").native 
    @session.wait_until {
      ( loader["style"].include?("display: none;") ||
        ! loader["style"].include?("display: block;") )
    }
  end
  
end