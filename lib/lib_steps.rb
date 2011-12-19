When /^i change app environment "(.*)"$/ do |app_env|
  Capybara.app_host = Warden::APP_ENV[app_env]["BB.ca Web BG"]
end


