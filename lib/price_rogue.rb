class PriceRogue
  require 'selenium-webdriver'
  
  LOGDIR = "#{ENV["WARDEN_HOME"]}/log"
  
  def initialize
    #start selenium htmlunit server
    selenium_jar = "#{ENV["WARDEN_HOME"]}lib/selenium-server-standalone-2.17.jar"
    @selenium_server = Selenium::Server.new(selenium_jar, :background => true)
    @selenium_server.start
    
    #this will open up a spare driver that will grab info from the best buy site
    caps = Selenium::WebDriver::Remote::Capabilities.htmlunit(:javascript_enabled => false)
    @hunit_driver = Selenium::WebDriver.for(:remote, :desired_capabilities => caps)
    @count = 0
  end
  
  def grab_prices(products)
    products["urls"].each { |sku,link|
      if ( link.downcase.include?("bestbuy.ca") )
        products["bn_prices"][sku] = grab_price_bb(link)
      end
    }
  end
  
  def refresh_server()
    @selenium_server.stop
    sleep 10
    @selenium_server.start
    caps = Selenium::WebDriver::Remote::Capabilities.htmlunit(:javascript_enabled => false)
    @hunit_driver = Selenium::WebDriver.for(:remote, :desired_capabilities => caps)
    sleep 5
  end
  
  def grab_price_bb(link)
  
    if ( @count == 30 )
      refresh_server
      @count = 0
    else
      @count += 1
    end
  
    @hunit_driver.navigate.to(link)
        
    if( @hunit_driver.page_source.downcase.include?("page not found") )
      return "Bad URL"
    end
    
    #wait until we find a price
    @hunit_driver.find_element(:css,".price")
    
    if ( @hunit_driver.page_source.downcase.include?("sale") )
      return @hunit_driver.find_element(:css,".price").text.gsub("$","").gsub(",","")
    else
      return @hunit_driver.find_element(:css,".priceblock .sale .price").text.gsub("$","").gsub(",","")
    end
  end
  
  def stop_server
    @hunit_driver.quit
    @selenium_server.stop    
  end
  
  # This gets run after the link check, and will report based
  # on the string input. It will save it to $WARDEN_HOME/log/job_id
  def document(job_id, products)
    job_id = job_id.gsub(" ","_")  
    bad_prices_file = "#{LOGDIR}/#{job_id}.yaml"
    
    # Now store the output, and append if run again
    File.open(bad_prices_file,"a") do |f|
      f.write(products.to_yaml)
    end
  end  
  
end