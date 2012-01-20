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

Then /^ensure that pageobject tab_one exists and is active$/ do
  @page.find_tab_one
  ( @page.tab_one_active? ).should == true
end

Then /^ensure that pageobject tab_two exists and not active$/ do
  @page.find_tab_two
  ( @page.tab_two_active? ).should == false  
end

Then /^ensure that pageobject tab_three exists and not active$/ do
  @page.find_tab_three
  ( @page.tab_three_active? ).should == false
end