Then /^ensure that the user is presented with a pageobject search box$/ do
  @page.find_search_field
end

Then /^ensure that pageobject Legal link exists$/ do
  @page.find_legal_link
end

Then /^ensure that pageobject start link exists$/ do
  @page.find_start_link
end

Then /^ensure that pageobject email link exists$/ do
  @page.find_email_link
end

Then /^ensure that pageobject Find My New tab exists and is active$/ do
  @page.find_find_my_new_tab
  ( @page.find_my_new_tab_active? ).should == true
end

Then /^ensure that pageobject Dealzone tab exists and not active$/ do
  @page.find_deal_zone_tab
  ( @page.deal_zone_tab_active? ).should == false
end

Then /^ensure that pageobject Top Rated exists and not active$/ do
  @page.find_top_rated_tab
  ( @page.top_rated_tab_active? ).should == false
end

When /^the user clicks on the deal zone tab$/ do
  @page.click_deal_zone_tab
end

Then /^ensure that the user is presented with View All Deals button$/ do
  @page.find_dealzone_all_deals_button
end

Then /^ensure that the user can click the View All Deals button$/ do
  @page.click_dealzone_all_deals_button
end