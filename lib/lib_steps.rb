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

# Given /^the user has changed to the default test target environment for the test application$/ do
  # step "Change to default test target environment for the test application"
# end
