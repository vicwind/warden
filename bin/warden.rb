#!/usr/bin/env ruby
#require 'ruby-debug'
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
    tc_ids = []

    if !options[:'tc_id_list'].empty?
      tc_ids = options[:'tc_id_list'].split(',')
    elsif !options[:file].empty?
      if File.exists? options[:file]
        file_content = open(options[:file]).read
        tc_ids = file_content.split("\n")
        tc_ids.select!{ |tc_id| tc_id.match(/[0-9]+/)  }
        tc_ids.each{ |tc_id| tc_id.strip!}
      else
        puts "Error: File \"#{options[:file]}\" does not exists!"
        exit 1
      end
    end
    #puts tc_ids.to_yaml
    run_by_tc_ids(tc_ids, options)
  end

  def self.show(options={})
    #the data format of this array is:
    #[ tc_id, project_name, feature_name, scenario_name, line_number]
    scenario_data_array = []

    #get all the scneario data and convert them to scenario_data_array format
    if options[:all] == true and options[:id].empty?
      tc_manager = self.test_case_manager
      tc_manager.find_all_projects().each do |project_name|
        tc_manager.find_all_features_by_project(project_name).each do |feature_name|
          scenarios =
            tc_manager.find_all_scenarios_by_feature(project_name, feature_name)
          if scenarios
            scenarios.each do |scenario_name, scenario_data_hash|
              scenario_data_array <<
              tc_manager.get_scenario_data_by_id(scenario_data_hash["id"]).
                insert(0,scenario_data_hash["id"])
            end
          end #of if scenarios
        end #of find_all_features_by_project(project_name) loop
      end #of find_all_projects() loop
    end

    if !options[:project].empty?
      if !options[:strict_mathcing]
        pattern = options[:project]
      else
        pattern = "^#{options[:project]}$" #strict equality matching
      end
      scenario_data_array = scenario_data_array.select{ |s| s[1].match(/#{pattern}/)}
    end

    if !options[:feature].empty?
      if !options[:strict_mathcing]
        pattern = options[:feature]
      else
        pattern = "^#{options[:feature]}$" #strict equality matching
      end
      scenario_data_array = scenario_data_array.select{ |s| s[2].match(/#{pattern}/)}
    end

    if !options[:scenario].empty?
      if !options[:strict_mathcing]
        pattern = options[:scenario]
      else
        pattern = "^#{options[:scenario]}$" #strict equality matching
      end
      scenario_data_array = scenario_data_array.select{ |s| s[3].match(/#{pattern}/)}
    end

    if !options[:id].empty?
      id = options[:id].to_i
      scenario_data_array.clear << self.test_case_manager.
        get_scenario_data_by_id(id).insert(0, id)
    end

    #p scenario_data_array
    self.print_test_cases(scenario_data_array)
    puts options

  end

  def self.test()
    require "#{File.dirname(__FILE__)}/../lib/warden_web_interface"
    
    WardenWebInterface.update_test_case_run_info_log(1, "lol")
  end

  def self.print_test_cases(scenario_data_array)
    if !scenario_data_array.empty?
      puts "TC_ID\tProject Name\tFeature Name\tScenario Name\tLine Number"
      scenario_data_array.each do |scenario_data|
        puts scenario_data.join("\t")
      end
      exit 0
    else
      $stderr.puts "No result found."
      exit 1
    end
  end

  #Execute all the test cases listed in the array, it will group the test case
  #by project, and then run "cucmber" command for each of the project
  #params:
  #  tc_ids: array, of integer test case ID
  #
  def self.run_by_tc_ids(tc_ids, options={})
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

    exit_code = 0 #track all the exit code of the each cucumber cmds
    projects.each do |project_name, found_features|
      if found_features['feature_files'].size > 0
        cucumber_run_cmd = "cucumber " + found_features['feature_files'].join(' ') + ' -n '+
          found_features['scenario_names'].join(' -n ')
        cucumber_run_cmd += ' --dry-run' if options[:'dry-run'] == true
        cucumber_run_cmd += ' --format Cucumber::Formatter::WardenWebPretty' if true
        puts cucumber_run_cmd
        #puts "---#{options.to_yaml}----------"
        system(cucumber_run_cmd)
        exit_code ||= $?
      end
    end

    if projects.size == 0
      $stderr.puts "Nothing to run."
      exit 1
    end

    exit exit_code
  end

end

c = Clint.new
c.usage do
  $stderr.puts <<EOF
Usage: #{File.basename(__FILE__)} run [-l|--tc_id_list <Tc_id1,Tc_id2,... >] [-f|--file <tc_ids_file>]
       #{File.basename(__FILE__)} show [-p|--project <project_name>]
                      [-f|--feature <feature_name>]
                      [-s|--scenario <scenario_name>]
                      [-i|--id <tc_id>] [-e|--strict_mathcing]
                      [-e|--strict_matching]
       #{File.basename(__FILE__)} [-h|--help]
EOF
end
c.help do
  $stderr.puts <<EOF
  run [--tc_id_list <Tc_id1,Tc_id2,... >] [--file <tc_ids_file>]
    --tc_id_list [-l]: Run the list of test case(Cucumber Scenario). The list is the the form of comma sepearted string.
    --file [-f] : Run the test case IDs listed in the file
  show [--project <project_name>] [--feature <feature_name>] [--scenario <scenario_name>] [--id <tc_id>] [--strict_mathcing]
    --project [-p] : show all the test case of the project
    --feature [-f] : show all the test case that matched the feature name pattern
    --scenario [-s] : show all the test case that matched the scenario name pattern
    --id [-i] : show the test case for the given tc_id
    --strict_mathcing : use string text matching for the pattern
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
    c.options :'tc_id_list' => String , :l => :'tc_id_list'
    c.options :file => String, :f => :file
  end
  if :show == subcommand
    c.options :all => true, :a => :all
    c.options :strict_mathcing => false, :e => :strict_mathcing
    c.options :project => String, :p => :project
    c.options :feature => String, :f => :feature
    c.options :scenario => String, :s => :scenario
    c.options :id => String, :i=> :id
  end
  if :test == subcommand
  end
  c.parse
end
