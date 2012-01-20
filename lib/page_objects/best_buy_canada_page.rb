class BestBuyCanadaPage < BuyingGuidePage

  def initialize(page_session)
    super(page_session)

    # initialize constant variables for BG sites
    constant_vars

    # Modified vars specific to BestBuyCanada site

    
    @tab_one_button_one     = "LAPTOPS"    # LAPTOPS             -- button
    @tab_one_button_two     = "DESKTOPS"   # DESKTOPS            -- button
    @tab_one_button_three   = "NETBOOKS"   # NETBOOKS            -- button
    
    # Top Rated Featured Products
    #@top_rated_featured_product_one   = "@top_rated_featured_product_one"
    #@top_rated_featured_product_two   = "@top_rated_featured_product_two"
    #@top_rated_featured_product_three = "@top_rated_featured_product_three"
    
    # Deal Zone Featured Products
    #@dealzone_featured_product_one   = "@dealzone_featured_product_one"
    #@dealzone_featured_product_two   = "@dealzone_featured_product_two"
    #@dealzone_featured_product_three = "@dealzone_featured_product_three"

    @dealzone_all_deals_button       = "View all deals" # View All Deals -- Button
    
  end

end