require 'rubygems'
require 'typhoeus'
require 'json'

class LinkChecker
  require 'yaml'
  require 'rack'
  
  attr_accessor :links_to_check
  LOGDIR = "#{ENV["WARDEN_HOME"]}/log"

  def initialize
    @broken_links = {}
    @links_to_check = {}
  end

  def broken_link?(url)
     res = Typhoeus::Request.get(url, {:follow_location => true, :max_redirects=>5})    
    if ( !( res.code == 200 ) )
      return true
      else
        return false
    end
  end

  # After collecting the links, run is issued to do the
  # parallel processing of all the links
  def run
    hydra = Typhoeus::Hydra.new
    hydra.disable_memoization
    @broken_links = {}
    
    # For every link, add it to the queue
    @links_to_check.each { |sku,url|
    
      req = Typhoeus::Request.new(url,{:max_redirects=>5})
           
      #collect links to validate in parallel
      req.on_complete { |res|
        # 200 is a 'valid' page. Everything else is bad
        if ( !( res.code == 200 ) )
          @broken_links[sku] =  url 
        end
      }
    
      hydra.queue( req ) 
    }
    
    # Now process the queue of links
    hydra.run
  
    @broken_links
  end
  
  # This gets run after the link check, and will report based
  # on the string input. It will save it to $WARDEN_HOME/log/job_id
  def document(warden_session)
    job_id = warden_session.scenario_name
    job_id = job_id.gsub(" ","_")  

    warden_session.external_data = @broken_links.to_json
    puts "Uh oh links: "
    puts warden_session.external_data
  end

  def working_url?(url, max_redirects=6)
    response = nil
    seen = Set.new
    loop do
      url = URI.parse( URI.encode(url) )
      break if seen.include? url.to_s
      break if seen.size > max_redirects
      seen.add(url.to_s)
      response = Net::HTTP.new(url.host, url.port).request_head(url.path)
      if response.kind_of?(Net::HTTPRedirection)
        url = response['location']
      else
        break
      end
    end
    #response
    response.kind_of?(Net::HTTPSuccess) && url.to_s
  end

  def invalid_links_to_json
    @broken_links.to_json
  end

end