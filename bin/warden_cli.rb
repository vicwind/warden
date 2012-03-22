#!/usr/bin/env ruby
require 'ruby-debug'
#require 'cucumber/rb_support/rb_dsl'
require "#{File.dirname(__FILE__)}/../lib/clint"
require "#{File.dirname(__FILE__)}/../core/test_case_manager"

class WardenCLI
  class << self
    def test_case_manager
      YAMLStoreTestCaseManager.create_new_test_case_map unless
      File.exists? YAMLStoreTestCaseManager.test_case_map_path
      @test_case_manager ||= YAMLStoreTestCaseManager.new()
    end
  end

  def self.run(options={})

    tc_ids = options[:'tc-id_list'].split(',')
    projects = {}
    tc_ids.each do |tc_id|
      tc_id = tc_id.to_i
      run_path = self.test_case_manager().tc_id_to_run_path(tc_id)
      if run_path
        project_name, feature_file, scenario_name, line_number =
          self.test_case_manager().get_scenario_data_by_id(tc_id)

        #get feature file and scenario name from run_path
        feature_file, scenario_name = run_path.split('-n')

        if !projects.has_key? project_name
          projects[project_name] = {
            'feature_files' => [feature_file],
            'scenario_names' => [scenario_name],
            'run_paths' => [run_path]
          }
        else
          projects[project_name]['feature_files'] << run_path
          projects[project_name]['scenario_names'] << scenario_name
          projects[project_name]['run_paths'] << run_path
        end
      else
        puts "tc_id: #{tc_id} does not exists!"
      end
    end

    projects.each do |project_name, found_features|
      if found_features['feature_files'].size > 0
        cucumber_run_cmd = "cucumber " + found_features['feature_files'].join(' ') + ' -n '+
          found_features['scenario_names'].join(' -n ')
        cucumber_run_cmd += ' --dry-run' if options[:'dry-run'] == true
        puts cucumber_run_cmd
        puts "---#{options.to_yaml}----------"
        system(cucumber_run_cmd)
      end
    end

    if projects.size == 0
        puts "Nothing to run."
        exit 1
    end
  end

end


c = Clint.new
c.usage do
  $stderr.puts <<EOF
Usage: #{File.basename(__FILE__)} run tc-<tc_id>
       #{File.basename(__FILE__)} bar [-t <thing>] [--thing=<thing>]
       #{File.basename(__FILE__)} [-h|--help]
EOF
end
c.help do
  $stderr.puts <<EOF
  -t <thing>, --thing=<thing>  OH HAI
  -h, --help                   show this help message
EOF
end
c.options :help => false, :h => :help
c.parse ARGV
if c.options[:help]
  c.help
  exit 1
end
c.subcommand WardenCLI do |subcommand|
  if :bar == subcommand
    c.options :thing => String, :t => :thing
  end
  if :run == subcommand
    c.options :'dry-run' => false, :d => :'dry-run'
    c.options :'tc-id_list' => String , :l => :'tc-id_list'
  end
  c.parse
end
