#!/usr/bin/env ruby
ENV['RAILS_ENV'] ||= 'development'

require File.expand_path('../../config/boot',  __FILE__)
require File.expand_path(ENV['WARDEN_WEB_HOME'] + '/config/environment.rb')
require 'daemon_spawn'
require 'date'

ActionMailer::Base.raise_delivery_errors = true

class Notifier < ActionMailer::Base
  default :from => "no-reply@#{`hostname -fs`.strip}.com",
    :return_path => "system@#{`hostname -fs`.strip}.com"

  def job_pass_rate_too_low(email, job_id)
    mail(:to => email, :subject => "[Warning]: Job #{job_id} has less than 80% pass rate") do |format|
      format.text { render text: "Job URL: http://autoqa.ihicentral.com:3000/test_case_run_info?job_id=#{job_id}"}
    end
  end
end

##Example Usage:
#  ./script/job_fail_notification.rb <email list> <job_name> <start_checking_at>
#  ./script/job_fail_notification.rb me@gmail.com daily_corn '5/5/2012'
#
class JobMonitorDaemon < DaemonSpawn::Base
  def start(args)
    @started_at = Time.now
    @checked_job_id = {}
    @need_to_stop = false
    @check_interval =  2# in second
    @email_list = args.delete_at(0).sub(',', ';')
    @job_name =  args[0] ? args.delete_at(0) : ''
    user_specified_start_time = args.delete_at(0)
    @check_time_stmp = user_specified_start_time ? DateTime.parse(user_specified_start_time).to_time : @started_at

    while !@need_to_stop
      result = TestRunJob.find_by_sql("
        select A.id, num_tc, num_passed
        from
        (SELECT j.id , count(j.id) as num_tc FROM test_run_jobs as j, test_case_run_infos as i
          where j.id = i.test_run_job_id and j.status = 'Done' and schedule_at > '#{@check_time_stmp}'
            and j.name like '%#{@job_name}%'
          group by j.id, i.status
        ) as A
        left join
        (SELECT j.id , count(i.status) as num_passed FROM test_run_jobs as j, test_case_run_infos as i
          where j.id = i.test_run_job_id and i.status = 'PASSED' and j.status = 'Done'
            and schedule_at > '#{@check_time_stmp}' and j.name like '%#{@job_name}%'
          group by j.id, i.status
        ) as B
        on A.id = B.id order by A.id desc
      ")
      result.each do |job|
        next if @checked_job_id[job.id]
        job.num_passed = 0 unless job.num_passed
        pass_rate = job.num_passed / job.num_tc.to_f
        if pass_rate < 0.8
          puts "[ #{Time.now} ]: Job #{job.id} has pass rate less than 80%, send notification email to #{@email_list}"
          Notifier.job_pass_rate_too_low(@email_list, job.id ).deliver
        end
        @checked_job_id[job.id] = true
      end

      #@check_time_stmp += @check_interval
      sleep @check_interval
      puts "Jobs are checked at #{Time.now}, checking job since #{@check_time_stmp}"
    end

  end

  def stop
    @need_to_stop = true
  end
end

JobMonitorDaemon.spawn!({
  :log_file => File.join(Rails.root, "log", "job_monitor.log"),
  :pid_file => File.join(Rails.root, 'log', 'job_monitor.pid'),
  :sync_log => true,
  :working_dir => Rails.root,
  :singleton => true
})
