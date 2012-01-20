class PriceRogue
  require 'nokogiri'
  require 'net/http'
  
  LOGDIR = "#{ENV["WARDEN_HOME"]}/log"
  
  def initialize
    #don't really nead this for much
    @count = 0
  end
  
  def grab_prices(products)
    products["urls"].each { |sku,link|
      if ( link.downcase.include?("bestbuy.ca") )
        products["bn_prices"][sku] = grab_price_bb(link)
      end
    }
  end
    
  def grab_price_bb(link)
    uri = URI(link)    
    site_source = Net::HTTP.get(uri).downcase 
    
    if( site_source.include?("page not found") || site_source.include?("object moved") )
      return "Bad URL"
    end
    
    doc = Nokogiri::HTML(site_source)
    
    if( doc.css("#pdpoverview").text.downcase.include?("on sale") )
      return doc.css("#pdpoverview .sale .price").text.gsub("$","").gsub(",","")
    else
      return doc.css("#pdpoverview .priceblock .price").text.gsub("$","").gsub(",","")
    end
      
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