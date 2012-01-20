################################################################################################
##  Interface Module                                                                           #
################################################################################################

module BuyingGuideInterface
  
  ########################################## 
  # BG methods that must be implemented    #
  ##########################################
  def verify_prices
    raise NotImplementedError.new("The verify prices method has not been implemented yet.")
  end
  
  def verify_images
    raise NotImplementedError.new("The verify images method has not been implemented yet.")
  end
      
  def constant_vars
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
      
    
    # Tabs 
      @find_my_new_tab     = "#find-my-new"      # -- :css
      @deal_zone_tab       = "#deal-zone"        # -- :css
      @top_rated_tab       = "#most-popular"     # -- :css
      @my_buying_guide_tab = "#my-buying-guide"  # -- :css
      
      
  ########################################################################################
  # BG Client Objects                                                                    #
  ########################################################################################                                                                                      #
  #                                                                                      #
  # Copy and paste these variables into the BuyingGuide client class you are creating    #
  #  and modify their values. See best_buy_canada_page.rb for a working example of this. # 
  #                                                                                      #
  # If an object needs to be added to this section, please follow the format. Name       #
  #   the object as abstractly as possible yet meaningful. Make it a global variable by  #
  #   putting @ at the front, and make it equal to a string with the exact name as the   #
  #   variable.                                                                          #
  #                                                                                      #
  #  ie:                                                                                 #
  #                                                                                      #
  #   @tab_one = "@tab_one"                                                              #
  #                                                                                      #
  #  Then add the variable to the end of the object array in the query_session_elements  # 
  #    method.                                                                           #
  #                                                                                      #
  ########################################################################################
  
  
      # Tab One Objects
      # Example:
      # Bestbuy.ca tab_one_button_one corresponds to the Laptops button
      # Bestbuy.ca tab_one_button_two corresponds to the Desktops button
      # Bestbuy.ca tab_one_button_three corresponds to the Netbooks button
      
      @tab_one_button_one     = "@tab_one_button_one"
      @tab_one_button_two     = "@tab_one_button_two"
      @tab_one_button_three   = "@tab_one_button_three"
      
      # tp_fp: Top Rated Featured Products
      @top_rated_featured_product_one   = "@top_rated_featured_product_one"
      @top_rated_featured_product_two   = "@top_rated_featured_product_two"
      @top_rated_featured_product_three = "@top_rated_featured_product_three"
      
      # dz_fp: Deal Zone Featured Products
      @dealzone_featured_product_one   = "@dealzone_featured_product_one"
      @dealzone_featured_product_two   = "@dealzone_featured_product_two"
      @dealzone_featured_product_three = "@dealzone_featured_product_three"
      @dealzone_all_deals_button       = "@dealzone_all_deals_button"
    
  ########################################## 
  # End of Vars to initialize              #
  ##########################################   
  end
  
  def query_session_elements
    ########################################## 
    # This array object will be used to make #
    # sure the proper variables  have been   #
    # modified for successful testing of a   #
    # client site.                           #
    #                                        #
    # When an object needs to be included    #
    # as a standard object then it needs to  #
    # be added in 2 places:                  #
    #                                        #
    #   1) Under the Buying Guide Objects    #
    #   2) In the array below                #
    #                                        #
    ##########################################   
    @objects = [ 
                 @tab_one_button_one,
                 @tab_one_button_two,
                 @tab_one_button_three,   
                 #@top_rated_featured_product_one,
                 #@top_rated_featured_product_two,  
                 #@top_rated_featured_product_three, 
                 #@dealzone_featured_product_one,   
                 #@dealzone_featured_product_two, 
                 #@dealzone_featured_product_three, 
                 @dealzone_all_deals_button 
               ] 
  
    # Check to make sure all client information has been modified  
    @objects.each { |obj|
      if obj.include?("@")
        raise NotImplementedError.new("#{obj} has not been modified with the client site information")
      end
    }
  end
    
end