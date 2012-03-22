require 'yaml'
#Provied the basic interface and tools needed to implment a real Test Case Manager
#most of the methods in this class need to be imlpemented in the sub-calss
class AbstractTestCaseManager

  def initialize
    @next_tc_id = get_next_tc_id_from_store()

  end

  def get_next_tc_id_from_store()
    
  end

  def register_scenario(project_name, scenario)
    raise Exception.new("You need to implement this methods in sub-class")
  end

  def update_scenario(project_name, scenario)

  end

  def delete_scenario(project, scenario)

  end

  def tc_id_to_run_path(tc_id)

  end

  def register_all()

  end

  def find_all_features_and_scenarios_by_project(project_name)

  end

  def find_all_scenarios_by_feature(feature)

  end

  def find_all_features_by_project(project_name)

  end

end

class YAMLStoreTestCaseManager < AbstractTestCaseManager

  class << self
    attr_accessor :test_case_map_path
    
  end
  #class instance variable, in placed of class variable
  @test_case_map_path = "#{ENV["WARDEN_HOME"]}/etc/test_case_map.yml"

  #attr_reader :scenario_look_up_map, :tc_id_map

  def initialize()
    @tc_id_map = load_yml_test_case_map()
    build_scenario_look_up_map() #it will initialize @scenario_look_up_map
    #puts @scenario_look_up_map.to_yaml
  end



  #params:
  # project_name: string, the name of the project the scenario belonges to
  # scenario: cucumber scenario instance
  #note: if setting register_example_rows = true, it will also register the
  #  example scenario of a scenario outline
  def register_scenario(project_name, scenario)

    register_example_rows = true

    scenario_example = scenario
    if scenario.class == Cucumber::Ast::OutlineTable::ExampleRow #for senario outline
      scenario_example = scenario.scenario_outline
    end

    feature_name, line_number = scenario_example.file_colon_line.split(':')

    feature_name = feature_name.sub(/.*features\//, '') #extract path only start from
                                                      #abcd.feature onward
    scenario_name = scenario.respond_to?("scenario_outline") ?
      scenario.scenario_outline.name : scenario.name

    scenario_data = [project_name, feature_name, scenario_name, line_number]
    scenario_data_hash = {
      'id' => @tc_id_map[:next_available_tc_id],
      'feature_name' => feature_name,
      'scenario_name' => scenario_name,
      'line_number' => line_number
    }

    unless scenario_exists_in_map?(project_name, scenario_data_hash)
      @tc_id_map[:tc_map][@tc_id_map[:next_available_tc_id]] = scenario_data
      @tc_id_map[:next_available_tc_id] += 1
      update_scenario_look_up_map(project_name, scenario_data_hash)
      save_yml_test_case_map()
    end

    #also register each example in the scenario outline, default not save
    if register_example_rows and scenario.respond_to?("scenario_outline")
      example_data_hash = scenario_data_hash.dup
      example_data = scenario_data.dup
      example_data_hash['scenario_name'] = scenario.name
      example_data[2] = scenario.name
      unless scenario_exists_in_map?(project_name, example_data_hash)
        example_data_hash['id'] = @tc_id_map[:next_available_tc_id]
        @tc_id_map[:tc_map][@tc_id_map[:next_available_tc_id]] = example_data
        @tc_id_map[:next_available_tc_id] += 1
        update_scenario_look_up_map(project_name, example_data_hash)
        save_yml_test_case_map()
      end
    end

  end


  #uses project_name, feature_name, and scenario_name to identify a unique scenario
  #params:
  # project_name: the name of the project this scenario belonges to
  # scenario_data_hash: a hash of the following format
  #   scenario_data_hash = {
  #     'id' => unique id
  #     'feature_name' => string
  #     'scenario_name' => string
  #     'line_number' => string
  #   }
  def scenario_exists_in_map?(project_name, scenario_data_hash)
    @scenario_look_up_map.has_key? project_name and
      @scenario_look_up_map[project_name].has_key? scenario_data_hash['feature_name'] and
      @scenario_look_up_map[project_name][scenario_data_hash['feature_name']][
        scenario_data_hash['scenario_name']]
  end

  def update_scenario_look_up_map(project_name, scenario_data_hash)
    unless @scenario_look_up_map.has_key? project_name
      @scenario_look_up_map[project_name] = {}
    end
    unless @scenario_look_up_map[project_name].has_key? scenario_data_hash['feature_name']
      @scenario_look_up_map[project_name][scenario_data_hash['feature_name']] = {}
    end
    unless @scenario_look_up_map[project_name][scenario_data_hash['feature_name']
        ].has_key? scenario_data_hash['scenario_name']
      @scenario_look_up_map[project_name][scenario_data_hash['feature_name']
        ][scenario_data_hash['scenario_name']] = {}
    end
    @scenario_look_up_map[project_name][scenario_data_hash['feature_name']
        ][scenario_data_hash['scenario_name']] = scenario_data_hash
  end

  def build_scenario_look_up_map
    @scenario_look_up_map = {}
    @tc_id_map[:tc_map].each do |tc_id, test_case_data|
      scenario_data_hash = {
        'id' => tc_id,
        'feature_name' => test_case_data[1],
        'scenario_name' => test_case_data[2],
        'line_number' => test_case_data[3]
      }
      update_scenario_look_up_map(test_case_data[0], scenario_data_hash)
    end
  end

  def load_yml_test_case_map()
    YAML::load_file(self.class.test_case_map_path)
  end

  def save_yml_test_case_map()
    FileUtils.mv(self.class.test_case_map_path, self.class.test_case_map_path + ".tmp_bak")
    File.open(self.class.test_case_map_path, "w"){ |file| file.puts(@tc_id_map.to_yaml)} if @tc_id_map
  end

  #params:
  #  project_name: string, a project's name
  #  feature_name: string
  #return: return the scenario hash data of each scenario in the feature file
  def find_all_scenarios_by_feature(project_name, feature_name)
    if @scenario_look_up_map.has_key? project_name
       features = @scenario_look_up_map[project_name]
       if features.has_key? feature_name
         features[feature_name]
       end
    end
  end

  #params:
  #  project_name: string, a project's name
  #return:
  #  an array of feature name for the projects
  def find_all_features_by_project(project_name)
    @scenario_look_up_map[project_name].keys if @scenario_look_up_map.has_key? project_name
  end

  #params:
  #  tc_id: number, the id for the scenario
  #return:
  #  the cucumber run path of the corresponding tc_id
  def tc_id_to_run_path(tc_id)
    if @tc_id_map[:tc_map].has_key? tc_id
      project_name, featuren_name, scenario_name, line_number =
        @tc_id_map[:tc_map][tc_id]

      "'#{ENV['WARDEN_HOME']}/projects/#{project_name}/features/#{featuren_name}'" + ' ' +
        '-n ' + scenario_name.inspect
    end
  end

  #params:
  #   tc_id: integer
  #return:
  #  the scenario data array
  def get_scenario_data_by_id(tc_id)
    @tc_id_map[:tc_map][tc_id] if @tc_id_map[:tc_map].has_key? tc_id
  end

  ###############
  ##Class Methods
  ###############
  #
  def self.create_new_test_case_map()
    new_test_case_map = {
      :next_available_tc_id => 1,
      :tc_map => {}
    }
    File.open(test_case_map_path, "w"){ |file| file.puts(new_test_case_map.to_yaml)}
  end
end
