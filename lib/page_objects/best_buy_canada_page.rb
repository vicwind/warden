class BestBuyCanadaPage < BuyingGuidePage

  def initialize(page_session)
    super(page_session)
    @tab_one        = "#find-my-new"
    @tab_two        = "#deal-zone"
    @tab_three      = "#most_popular"
    @tab_four       = "#my-buying-guide"
  end

end