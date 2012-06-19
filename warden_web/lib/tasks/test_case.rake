namespace :registration do

  desc "Register test case into the WardenWeb DB"
  task :run => :environment do
    test_case_map =  ENV['TEST_CASE_MAP_FILE'] || "#{ENV['WARDEN_HOME']}/etc/test_case_map.yml"
    test_cases_info = YAML::load_file(test_case_map)

    test_cases_info[:tc_map].each do |tc_id, tc|

      warden_project = WardenProject.find_or_create_by_name(tc[0])

      target_tc = TestCase.find(:all, :conditions => {
        name: tc[2],
        feature_name: tc[1],
        warden_project_id: warden_project.id
      })

      if target_tc.empty?
        TestCase.create({
          name: tc[2],
          feature_name: tc[1],
          feature_file_path: "./#{tc[0]}/#{tc[1]}",
          register_at: Time.now,
            tc_id: tc_id,
            warden_project: warden_project
        })
        puts "Test case '#{warden_project.name}:#{tc[1]}:#{tc[2]}' at './#{tc[0]}/#{tc[1]}' has been registered into DB."
      end
    end
  end #of task
end

