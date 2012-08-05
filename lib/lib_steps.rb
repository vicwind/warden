When /^Change test target environment to "(.*)" for "(.*)" application$/ do |app_env, app_name|
  Capybara.app_host = Warden::APP_ENV[app_env][app_name]
  step_detail = "Target environment '#{app_env}', " +
    "test application '#{app_name}'"
  step_detail += " with locale '#{ENV["WARDEN_TEST_TARGET_LOCALE"]}'" if ENV["WARDEN_TEST_TARGET_LOCALE"]

  Warden.add_test_target_detail(step_detail)
  visit("/")
end

When /^Change to default test target environment for "(.*)" application$/ do |app_name|
  Capybara.app_host = Warden::APP_ENV[ ENV[ "WARDEN_TEST_TARGET_ENV" ] ][ app_name ]
  step_detail = "Target environment '#{ENV[ "WARDEN_TEST_TARGET_ENV" ] }', " +
    "test application '#{app_name}'"
  step_detail += " with locale '#{ENV["WARDEN_TEST_TARGET_LOCALE"]}'" if ENV["WARDEN_TEST_TARGET_LOCALE"]

  Warden.add_test_target_detail(step_detail)
  visit("/")
end

When /^Change to default test target environment for the test application$/ do
  Capybara.app_host = Warden::APP_ENV[ ENV[ "WARDEN_TEST_TARGET_ENV" ] ][ ENV["WARDEN_TEST_TARGET_NAME"] ]
  step_detail = "Target environment '#{ENV[ "WARDEN_TEST_TARGET_ENV" ] }', " +
    "test application '#{ENV["WARDEN_TEST_TARGET_NAME"] }'"
  step_detail += " with locale '#{ENV["WARDEN_TEST_TARGET_LOCALE"]}'" if ENV["WARDEN_TEST_TARGET_LOCALE"]

  Warden.add_test_target_detail(step_detail)
  visit("/")

  puts "Capybara App Host"
  puts Capybara.app_host
end

Given /^[T|t]he user has changed to the default test target environment for the test application$/ do
  step "Change to default test target environment for the test application"
end

Then /^Capture the screen shot$/ do
  @warden_session.capture_screen_shot()
end

# Given /^the user has changed to the default test target environment for the test application$/ do
  # step "Change to default test target environment for the test application"
# end

Given /^user is using page objects to access the default test target environment for the test application$/ do
   Capybara.app_host = Warden::APP_ENV[ ENV[ "WARDEN_TEST_TARGET_ENV" ] ][ ENV["WARDEN_TEST_TARGET_NAME"] ]
  page_name = ENV[ "WARDEN_TEST_TARGET_NAME" ]

  puts "#{ Warden::PAGE_OBJECTS[page_name] }"
  page_class = Object.const_get("#{ Warden::PAGE_OBJECTS[page_name] }")
  
  #puts "Page Class: #{page_class}"
  
  step_detail = "Target environment '#{ENV[ "WARDEN_TEST_TARGET_ENV" ] }' ,"+
    "test application '#{ENV["WARDEN_TEST_TARGET_NAME"] }'"
  step_detail += " with locale '#{ENV["WARDEN_TEST_TARGET_LOCALE"]}'" if ENV["WARDEN_TEST_TARGET_LOCALE"]

  Warden.add_test_target_detail(step_detail)
  @page = page_class.new(Capybara.current_session, @warden_session)

  # staging specific data, not needed for other test environments
  if ( ENV[ "WARDEN_TEST_TARGET_ENV" ] == "staging" )
    base = "http://bg2011-stg:qaMeBRa2@bg2011-static.ihidevelopment.com/"
    @page.visit_site(base)
    #breakpoint
    base = base.gsub("bg2011-stg:qaMeBRa2@","")+Capybara.app_host
    Capybara.app_host = base
    @page.visit_site(base)
  else
    @page.visit_site(Capybara.app_host)
  end
  
end

# Commonly used steps

And /^the user clicked the "([^"]*)" button$/ do |type|
  case(type)
  when "@type_button_one"
    @page.click_type_button_one
  when "@type_button_two"
    @page.click_type_button_two
  when "@type_button_three" 
    @page.click_type_button_three
  end  
end

When /^the user clicked the category "([^"]*)" button$/ do |category|
  case(category)
  when "@category_button_one"
    @page.click_category_button_one
  when "@category_button_two"
    @page.click_category_button_two
  when "@category_button_three"  
    @page.click_category_button_three  
  when "@category_browse_button_one"
    @page.click_category_browse_button_one
  when "@category_browse_button_two"
    @page.click_category_browse_button_two
  when "@category_browse_button_three"
    @page.click_category_browse_button_three
  end
end

When /^the user has clicked the go to results button$/ do
  @page.click_go_to_results_button
end

When /^the user clicked the Start button$/ do
  @page.click_start_link
end

Given /^the user has visited the ISA site$/ do
  step 'Change to default test target environment for the test application'
end