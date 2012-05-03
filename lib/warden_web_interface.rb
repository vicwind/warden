#################################
#This interface will serve as the communication API
#between Warden and WardenWeb
#################################
#
require 'faraday'
module WardenWebInterface

  WARDEN_WEB_BASE_URL = "http://localhost:5000"
  class << self
    def connection()
      @connection ||= ""
    end
  end

  #setting a particular scenario to be pass/fail
  def self.update_test_case_run_info_status(id, status)

    conn = self.build_connection(WARDEN_WEB_BASE_URL)
    conn.put "/test_case_run_info/#{id}.json",
      { :test_case_run_info => {:status => status} }  # POST "name=maguro" to http://sushi.com/nigiri

    # post payload as JSON instead of "www-form-urlencoded" encoding:
    # conn.post do |req|
    #   req.url '/nigiri'
    #   req.headers['Content-Type'] = 'application/json'
    #   req.body = '{ "name": "Unagi" }'
    # end
  end

  def self.build_connection(http_base_url)
    conn = Faraday.new(:url => http_base_url) do |builder|
      builder.use Faraday::Request::UrlEncoded  # convert request params as "www-form-urlencoded"
      builder.use Faraday::Response::Logger     # log the request to STDOUT
      builder.use Faraday::Adapter::NetHttp     # make http requests with Net::HTTP

      # or, use shortcuts:
      builder.request  :url_encoded
      builder.response :logger
      builder.adapter  :net_http
    end

    conn
  end

end

