When /^Change test target environment to "(.*)" for "(.*)" application$/ do |app_env, app_name|
  Capybara.app_host = Warden::APP_ENV[app_env][app_name]
  step_detail = "Target environment '#{app_env}', " +
    "test application '#{app_name}'"
  step_detail += " with locale '#{Warden::Config::test_target_locale}'" if Warden::Config::test_target_locale

  Warden.add_test_target_detail(step_detail)
  visit("/")
end

When /^Change to default test target environment for "(.*)" application$/ do |app_name|
  Capybara.app_host = Warden::APP_ENV[ Warden::Config::test_target_env ][ app_name ]
  step_detail = "Target environment '#{Warden::Config::test_target_env}', " +
    "test application '#{app_name}'"
  step_detail += " with locale '#{Warden::Config::test_target_locale}'" if Warden::Config::test_target_locale

  Warden.add_test_target_detail(step_detail)
  visit("/")
end

When /^Change to default test target environment for the test application$/ do
  Capybara.app_host = Warden::APP_ENV[ Warden::Config::test_target_env ][ Warden::Config::test_target_name ]
  step_detail = "Target environment '#{Warden::Config::test_target_name}', " +
    "test application '#{Config::test_target_name}'"
  step_detail += " with locale '#{Warden::Config::test_target_locale}'" if Warden::Config::test_target_locale

  Warden.add_test_target_detail(step_detail)
  visit("/")
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
  Capybara.app_host = Warden::APP_ENV[ Warden::Config::test_target_env ][ Warden::Config::test_target_name ]
  page_name = Warden::Config::test_target_name

  page_class = Object.const_get("#{ Warden::PAGE_OBJECTS[page_name] }")
  step_detail = "Target environment '#{Warden::Config::test_target_env}' ,"+
    "test application '#{Warden::Config::test_target_name}'"
  step_detail += " with locale '#{Warden::Config::test_target_locale}'" if Warden::Config::test_target_locale

  Warden.add_test_target_detail(step_detail)
  @page = page_class.new(Capybara.current_session, @warden_session)

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
