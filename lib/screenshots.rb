module Warden
  def embed_screenshot(id,scenario)
    #%x(scrot #{$ROOT_PATH}/images/#{id}.png)
    if scenario.failed?
      File.open("./#{scenario.name.gsub(/ /,'_')}.jpg",'wb') do |f|
        f.write(Base64.decode64(page.driver.browser.screenshot_as(:base64)))
      end
    end 
  end
end
#World(Screenshots)


# Only take screenshot for scenarios or features tagged @screenshot
#
# After(@screenshots) do
# embed_screenshot("screenshot-#{Time.new.to_i}")
# end
#
# Only take screenshot on failures

After do |scenario|
  embed_screenshot("screenshot-#{Time.new.to_i}", scenario) if scenario.failed?
end


