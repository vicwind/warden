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

  page_class = Object.const_get("#{ Warden::PAGE_OBJECTS[page_name] }")
  step_detail = "Target environment '#{ENV[ "WARDEN_TEST_TARGET_ENV" ] }' ,"+
    "test application '#{ENV["WARDEN_TEST_TARGET_NAME"] }'"
  step_detail += " with locale '#{ENV["WARDEN_TEST_TARGET_LOCALE"]}'" if ENV["WARDEN_TEST_TARGET_LOCALE"]

  Warden.add_test_target_detail(step_detail)
  @page = page_class.new(Capybara.current_session)
  @page.visit
end

# Commonly used steps

And /^the user has clicked the "([^"]*)" button$/ do |type|
  type_button = find_button(type)
  type_button.click
end

And /^the user has also clicked the "([^"]*)" button$/ do |category|
  category_button = find_button(category)
  category_button.click
end

When /^the user has clicked the go to results button$/ do
  results_button = find_button('Go to results')
  results_button.click
  # to verify that the results page has loaded before continuing
	find_by_id('best_match')
end
