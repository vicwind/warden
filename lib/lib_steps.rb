When /^Change test target environment to "(.*)" for "(.*)" application$/ do |app_env, app_name|
  Capybara.app_host = Warden::APP_ENV[app_env][app_name]
  visit("/")
end

When /^Change to default test target environment for "(.*)" application$/ do |app_name|
  Capybara.app_host = Warden::APP_ENV[ ENV[ "WARDEN_TEST_TARGET_ENV" ] ][ app_name ]
  visit("/")
end

When /^Change to default test target environment for the test application$/ do
  Capybara.app_host = Warden::APP_ENV[ ENV[ "WARDEN_TEST_TARGET_ENV" ] ][ ENV["WARDEN_TEST_TARGET_NAME"] ]
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
