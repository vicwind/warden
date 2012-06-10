#!/usr/bin/env ruby
require 'ruby-debug'
ENV['RAILS_ENV'] ||= 'development'


require File.expand_path('../../config/boot',  __FILE__)
require File.expand_path(ENV['WARDEN_WEB_HOME'] + '/config/environment.rb')
require 'daemon_spawn'

class ResqueWorkerDaemon < DaemonSpawn::Base
  def start(args)
    begin
      queues = (ENV['QUEUES'] || ENV['QUEUE']).to_s.split(',')
      @worker = Resque::Worker.new(*queues) # Specify which queues this worker will process
    rescue Resque::NoQueueError
      abort "set QUEUE env var, e.g. $ QUEUE=critical,high rake resque:work"
    end

    @worker.verbose = ENV['LOGGING'] || ENV['VERBOSE'] # Logging - can also set vverbose for 'very verbose'
    @worker.work
  end

  def stop
    @worker.try(:shutdown)
  end
end

ResqueWorkerDaemon.spawn!({
  :processes => ENV['WORKER_NUMBER'].to_i || 1,
  :log_file => File.join(Rails.root, "log", "resque_worker.log"),
  :pid_file => File.join(Rails.root, 'log', 'resque_worker.pid'),
  :sync_log => true,
  :working_dir => Rails.root,
  :singleton => true
})
