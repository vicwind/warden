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
      
      @recent_searches_area = "#recent_searches" # -- :css      
      @favorites_area       = ""                 # -- :css
    
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
      #
      # Example:
      #
      # Bestbuy.ca type_button_one corresponds to the Laptops button
      # Bestbuy.ca type_button_two corresponds to the Desktops button
      # Bestbuy.ca type_button_three corresponds to the Netbooks button
      
      @type_button_one     = "@type_button_one"
      @type_button_two     = "@type_button_two"
      @type_button_three   = "@type_button_three"

      # Bestbuy.ca category_button_one corresponds to the Home button
      # Bestbuy.ca category_button_two corresponds to the Work button
      # Bestbuy.ca category_button_three corresponds to the School button
      
      @category_button_one   = "@category_button_one"
      @category_button_two   = "@category_button_two"
      @category_button_three = "@category_button_three"
      
      @category_browse_button_one   = "@category_browse_button_one"
      @category_browse_button_two   = "@category_browse_button_two"
      @category_browse_button_three = "@category_browse_button_three"
      
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
                 @type_button_one,
                 @type_button_two,
                 @type_button_three,   
                 @category_button_one,
                 @category_button_two,
                 @category_button_three,
                 @category_browse_button_one,
                 @category_browse_button_two,
                 @category_browse_button_three,
                 @dealzone_all_deals_button 
               ] 
  
    # Check to make sure all client information has been modified  
    @objects.each { |obj|
      if obj.include?("@")
        raise NotImplementedError.new("#{obj} has not been modified with the client site information")
      end
    }
  end
    
  ################################################# 
  # Tab Interaction                               #
  #################################################
    
      ##########################
      # Find My New Tab        #
      ##########################
      def find_find_my_new_tab
        raise NotImplementedError.new("find_find_my_new_tab has not been implemented yet")
      end
    
      def find_my_new_tab_active?
        raise NotImplementedError.new("find_my_new_tab_active? has not been implemented yet")
      end
    
      def click_find_my_new_tab
        raise NotImplementedError.new("click_find_my_new_tab has not been implemented yet")
      end
          
      def click_product_type(type)
        raise NotImplementedError.new("click_product_type has not been implemented yet")
      end   
          
      def click_type_button_one
        raise NotImplementedError.new("click_type_button_one has not been implemented yet")
      end 
           
      def click_type_button_two
        raise NotImplementedError.new("click_type_button_two has not been implemented yet")
      end
       
      def click_type_button_three
        raise NotImplementedError.new("click_type_button_three has not been implemented yet")
      end
      
      def click_category_browse_button_one
        raise NotImplementedError.new("click_category_browse_button_one has not been implemented yet")
      end
     
      def click_category_browse_button_two
        raise NotImplementedError.new("click_category_browse_button_two has not been implemented yet")
      end
       
      def click_category_browse_button_three
        raise NotImplementedError.new("click_category_browse_button_three has not been implemented yet")
      end     
      
      def verify_find_my_new_tab_loaded
        raise NotImplementedError.new("verify_find_my_new_tab_loaded has not been implemented yet")
      end    
          
      ########################## 
      # Dealzone Tab           #
      ##########################
      def find_deal_zone_tab
        raise NotImplementedError.new("find_deal_zone_tab has not been implemented yet")
      end
    
      def deal_zone_tab_active?
        raise NotImplementedError.new("deal_zone_tab_active? has not been implemented yet")
      end
    
      def click_deal_zone_tab
        raise NotImplementedError.new("click_deal_zone_tab has not been impemented yet")
      end
    
      def find_dealzone_all_deals_button
        raise NotImplementedError.new("find_dealzone_all_deals_button has not been implemented yet")
      end
    
      def click_dealzone_all_deals_button
        raise NotImplementedError.new("click_dealzone_all_deals_button has not been impemented yet")
      end
    
      def verify_deal_zone_tab_loaded
        raise NotImplementedError.new("verify_deal_zone_tab_loaded has not been implemented yet")
      end
    
      ##########################
      # Top Rated Tab          #
      ##########################
      def find_top_rated_tab
        raise NotImplementedError.new("find_top_rated_tab has not been implemented yet")
      end
    
      def top_rated_tab_active?
        raise NotImplementedError.new("to_rated_tab_active? has not been implemented yet")
      end
    
      def click_top_rated_tab
        raise NotImplementedError.new("click_top_rated_tab has not been implemented yet")
      end
      
      def verify_top_rated_tab_loaded
        raise NotImplementedError.new("verify_top_rated_tab_loaded has not been implemented yet")
      end
    
      ##########################
      # My Buying Guide Tab    #
      ##########################
      def find_my_buying_guide_tab
        raise NotImplementedError.new("find_my_buying_guide_tab has not been implemented yet")
      end
    
      def my_buying_guide_tab_active?
        raise NotImplementedError.new("my_buying_guide_tab_active? has not been implemented yet")
      end
      
      def click_my_buying_guide
        raise NotImplementedError.new("click_my_buying_guide has not been implemented yet")
      end

  ############################################# 
  # Favorites capabilities of the BG platform #
  ############################################# 

      def add_first_product_to_favorites
        raise NotImplementedError.new("add_first_product_to_favorites has not been implemented yet")
      end    
    
end