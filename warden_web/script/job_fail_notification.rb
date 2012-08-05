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

  def job_pass_rate_too_low(email, job_id, output)
    mail(:to => email, :subject => "[Warning]: Job #{job_id} has less than 80% pass rate") do |format|
      #format.text { render text: " #{output}"}
      format.text { output }
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
    @check_interval =  2 # in second
    @email_list = args.delete_at(0).sub(',', ';')
    @job_name =  args[0] ? args.delete_at(0) : ''
    user_specified_start_time = args.delete_at(0)
    @check_time_stmp = user_specified_start_time ? DateTime.parse(user_specified_start_time).to_time : @started_at

    while !@need_to_stop
      result = TestRunJob.find_by_sql("
        select A.id, A.num_tc, B.num_passed
        from
        (SELECT j.id , count(j.id) as num_tc FROM test_run_jobs as j, test_case_run_infos as i
          where j.id = i.test_run_job_id and j.status = 'Done' and schedule_at > '#{@check_time_stmp}'
            and j.name like '%#{@job_name}%'
          group by j.id
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

        # Wait for at least a 30 second interval before saying it's "Finished" -- prevents premature email
        if pass_rate < 0.8 && ( ( Time.now - TestRunJob.find(job.id).updated_at ) > 30 )
          puts "[ #{Time.now} ]: Job #{job.id} has pass rate less than 80%, send notification email to #{@email_list}"
          output = grab_project_statistics(job.id)
          Notifier.job_pass_rate_too_low(@email_list, job.id, output ).deliver
        end

        # Wait for at least a 30 second interval before saying it's "Finished"
        if ( ( Time.now - TestRunJob.find(job.id).updated_at ) > 30 )
          @checked_job_id[job.id] = true 
          puts "[ #{Time.now} ]: Checked Job #{job.id} at #{pass_rate * 100}% pass rate with #{job.num_passed} passed out of #{job.num_tc} test cases."
        end
      end

      #@check_time_stmp += @check_interval
      sleep @check_interval
      puts "Jobs are checked at #{Time.now}, checking job since #{@check_time_stmp}"
    end
    
  end

  def stop
    @need_to_stop = true
  end

  def grab_project_statistics(job_id)
    pst      = ActiveSupport::TimeZone.new("Pacific Time (US & Canada)")
    job      = TestRunJob.find(job_id)
    time     = job.schedule_at.in_time_zone(pst)
    project_statistics = WardenProject.get_projects_in_job_statistics(job_id)

    passed     = project_statistics[0]
    queued     = project_statistics[1]
    failed     = project_statistics[2]
    failed_tcs = project_statistics[3]

    all_keys = passed.keys + failed.keys

    output = ""
    output << "=============================================================\n\n"
    output << "Failure Stats for job '#{job.name}' scheduled on #{time.strftime('%m/%d/%y at %H:%M PST')}\n\n"
    output << "http://autoqa.ihicentral.com:3000/test_case_run_info?job_id=#{job_id} \n\n"
    output << "=============================================================\n"
    output << "\n"
    output << "Projects: \n"
    output << "\n"

    all_keys.each { | key |
      rate = "#{ ( passed[key]*100 / ( passed[key]+failed[key] ) ) }%"
      output << "#{rate.rjust(4,' ')} Success for #{key}\n" 
    }

    output << "\n"
    output << "=============================================================\n\n"

    failed.each { |key, value| 
      if failed[key] > 0
        output << "  Failed (#{failed_tcs[key].length}) Testcases for #{key}: \n\n"
        failed_tcs[key].each { |tc| output << "    #{tc}\n" }
      end
    }

    output
  end

end

JobMonitorDaemon.spawn!({
  :log_file => File.join(Rails.root, "log", "job_monitor.log"),
  :pid_file => File.join(Rails.root, 'log', 'job_monitor.pid'),
  :sync_log => true,
  :working_dir => Rails.root,
  :singleton => true
})
