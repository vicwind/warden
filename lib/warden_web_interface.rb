#################################
#This interface will serve as the communication API
#between Warden and WardenWeb
#################################
#
require 'faraday'
require "#{ENV['WARDEN_CONFIG_DIR']}/config"

module WardenWebInterface

  WARDEN_WEB_BASE_URL = Warden::Config::WEB_BASE_URL

  class << self

    def connection()
      @connection ||= ""
    end

    def log_buffer()
      @log_buffer ||= []
    end

    def log_io
      @log_io
    end

    def log_io=(io)
      @log_io = io
    end
  end

  def self.update_test_case_run_info(id, attributes)
    conn = self.build_connection(WARDEN_WEB_BASE_URL)
    conn.put "/test_case_run_info/#{id}.json",
      { :test_case_run_info => attributes }
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

  #updaing the log for the scenario
  def self.update_test_case_run_info_log(id, log_content)

    conn = self.build_connection(WARDEN_WEB_BASE_URL)
    conn.put "/test_case_run_info/#{id}.json",
      { :test_case_run_info => {:test_case_log => log_content} }
  end

  #params:
  # tc_id: array of test case that needs to be ran
  # job_optiones:
  #   a hash to other optional params:
  #   :job_name => string, job name
  #   :environment => string, application environemnt, e.g prd, qa, development
  #   :requester => string
  #   :job_type => string
  def self.schedule_job_run(tc_ids, job_options)
    conn = self.build_connection(WARDEN_WEB_BASE_URL)

    result = conn.post "/test_case/run_test_job", {
      :'tc_ids' => tc_ids,
      :app_environment => job_options[:environment],
      :job_name => job_options[:job_name]
    }
  end


  def self.build_connection(http_base_url)
    conn = Faraday.new(:url => http_base_url) do |builder|
      builder.use Faraday::Request::UrlEncoded  # convert request params as "www-form-urlencoded"
      builder.use Faraday::Response::Logger     # log the request to STDOUT
      builder.use Faraday::Adapter::NetHttp     # make http requests with Net::HTTP
      # or, use shortcuts:
      # builder.request  :url_encoded
      # builder.response :logger
      # builder.adapter  :net_http
    end

    conn
  end

  def self.write_log_to_buffer(scenario_log)
    log_buffer << scenario_log
  end

  def self.read_log_from_buffer()
    log_buffer.delete_at(0)
  end

end

