require 'rubygems'
require 'typhoeus'

class LinkChecker
  require 'yaml'
  
  attr_accessor :links_to_check
  LOGDIR = "#{ENV["WARDEN_HOME"]}/log"

  def initialize
    @broken_links = {}
    @links_to_check = {}
  end

  # After collecting the links, run is issued to do the
  # parallel processing of all the links
  def run
    hydra = Typhoeus::Hydra.new
    hydra.disable_memoization
    @broken_links = {}
    
    # For every link, add it to the queue
    @links_to_check.each { |sku,url|
    
      req = Typhoeus::Request.new(url,{:max_redirects=>3})
           
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
  def document(job_id)
    job_id = job_id.gsub(" ","_")  
    broken_links_file = "#{LOGDIR}/#{job_id}.yaml"
    
    # Now store the output, and append if run again
    File.open(broken_links_file, "a") do |f|
      f.write(@broken_links.to_yaml)
    end
  end
  
end