Given /^i am on the buying guide page/ do
  puts Warden::APP_ENV
  #puts  @warden_session.current_scenario
  debugger
  visit("/bg/init/?inst_id=217&impl_id=300&locale=en_us")
  page.should have_content('It will only take a few minutes to complete.')
  # "need_help.png"
end

When /^i am inside the netbook category$/ do
  find_button('NETBOOKS').click 
  #wait_until { page.find(:css, 'button[title="Browse All Netbooks"]' )}
  find_button('Browse All Netbooks').click 
end

Then /^i should be able to see all netbooks/ do

  #sleep 5
 # wait_until { page.find(:css, 'tr[class="product"]' )}
  #debugger
  page.should have_content('products found.')
end


