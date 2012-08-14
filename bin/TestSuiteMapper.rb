############################################################################################
#                                                                                          #
# This utility allows the user to create .suite files                                      #
# based on the test_case_map.yml                                                           #
#                                                                                          #
############################################################################################
#                                                                                          #
# Usage: Mapper.rb [options]                                                               #
#                                                                                          #
# Specific options:                                                                        #
#     -t FILENAME                      The location of the Testcase mapping file           #
#     -o FILENAME                      The name of the file ot output to                   #
#         --exclude-tc-ids X,Y,Z       The list of testcase ids to exclude from the suite  #
#         --feature-files x,y,z        The list feature files to include in the suite      #
#         --scenarios x,y,z            The list feature files to include in the suite      #
#         --projects x,y,z             The list of projects to include in the suite        #
#         --list-projects, --[no-]list-projects                                            #
#                                      List projects                                       #
#         --list-scenarios, --[no-]list-scenarios                                          #
#                                      List scenarios                                      #
#         --list-feature-files, --[no-]list-feature-files                                  #
#                                      List feature files                                  #
#     -h, --help                       Show this message                                   #
#                                                                                          #
############################################################################################

class SuiteMapper
  require 'yaml'
  require 'optparse'
  require 'ostruct'

  def self.process_ids(args)

    options = self.parse(args)

    warden_home = ENV["WARDEN_HOME"]
    warden_home = warden_home[0..-2] if !warden_home.empty? && warden_home[-1] == "/"

    # Load the testcase map file
    if warden_home.empty? && ( options.tc_map.empty? || !File.exists?(options.tc_map ) )
      puts "Error:\n"
      puts "Can't locate test case mapping file. Please ensure you have set the WARDEN_HOME environment variable"
      puts "or have specified a custom loaction using the -t option."
      exit 1 
    end

    # Load up YML
    if !options.tc_map.empty? 
      tc_map = options.tc_map
    else
      tc_map = "#{ENV["WARDEN_HOME"]}/etc/test_case_map.yml"
    end

    map = YAML::load_file(tc_map)[:tc_map]

    exclude_list = options.tcids_to_exclude.collect {|i| i.to_i }

    # Remove the proper TC ids
    tc_ids = map.keys - exclude_list

    feature_tcids   = []
    projects_tcids  = []
    scenarios_tcids = []

    # Projects filter
    if !options.projects.empty?
      options.projects.each { |project| 
        tc_ids.each { |key|
          projects_tcids.push(key) if map[key][0] == project
        }
      }
      if projects_tcids.empty?
        puts "Error: Invalid (or not found) Project name"
        exit 1
      end
    end

    # Features filter
    if !options.feature_files.empty?
      options.feature_files.each { |feature| 
        tc_ids.each { |key|
          feature_tcids.push(key) if map[key][1] == feature
        }
      }
      if feature_tcids.empty?
        puts "Error: Invalid (or not found) Feature filename"
        exit 1
      end
    end

    # Scenarios filter
    if !options.scenarios.empty?
      options.scenarios.each { |scenario| 
        tc_ids.each { |key|
          scenarios_tcids.push(key) if map[key][2] == scenario 
        }
      }
      if scenarios_tcids.empty?
        puts "Error: Invalid (or not found) Scenario name"
        exit 1
      end
    end

    output_tcids  = []
    filters = []

    # Create array filters
    filters.push( projects_tcids )  if !projects_tcids.empty?
    filters.push( feature_tcids )   if !feature_tcids.empty?  
    filters.push( scenarios_tcids ) if !scenarios_tcids.empty?

    if filters.empty?
      # No filters, so spit out everything
      finale(options, map, tc_ids)
    else
      # Appy these filters
      output_tcids = tc_ids
      filters.each { |filter| output_tcids = output_tcids & filter }
      finale(options, map, output_tcids)
    end

  end

  # Roll everything up and output it
  def self.finale(options, map, tc_ids)
    output = []

    # If they want to list Projects
    if ( options.list_projects )
      output.push("Projects: ")
      tc_ids.each { |key| output.push("  #{map[key][0]}") }
    end

    # If they want to list Features
    if ( options.list_features )
      output.push("Features: ")
      tc_ids.each { |key| output.push("  #{map[key][1]}") }
    end

    # If they want to list Scenarios
    if ( options.list_scenarios )
      output.push("Scenarios: ")
      tc_ids.each { |key| output.push("  #{map[key][2]}") }
    end

    puts output.uniq

    # If there is an output file directive
    if ( !options.output_file.empty? )
      temp = ""
      tc_ids.each { |id| temp += "#{id}\n"}
      File.open( options.output_file, 'a+') {|f| f.write(temp.strip) }
    else
      puts tc_ids
    end
  end

  # Parse the input options
  def self.parse(args)
    # The options specified on the command line will be collected in *options*.
    # We set default values here.
    options = OpenStruct.new
    options.projects      = []
    options.scenarios     = []
    options.feature_files = []
    options.output_file   = ""
    options.tcids_to_exclude = []
    options.list_projects = false
    options.list_scenarios = false
    options.list_features = false
    options.tc_map = ""

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: Mapper.rb [options]"

      opts.separator ""
      opts.separator "Specific options:"

      # Select custom location of tc map file
      opts.on("-t FILENAME" , "The location of the Testcase mapping file") do |map|
        options.tc_map << map
      end

      # Output file name
      opts.on("-o FILENAME", "The name of the file ot output to") do |file|
        options.output_file << file
      end

      # Accept list of feature files to include
      opts.on("--exclude-tc-ids X,Y,Z", Array, "The list of testcase ids to exclude from the suite") do |tc_ids|
        options.tcids_to_exclude = tc_ids
      end

      # Accept list of feature files to include
      opts.on("--feature-files x,y,z", Array, "The list feature files to include in the suite") do |feature_files|
        options.feature_files = feature_files
      end

      # Accept list of scenarios to include
      opts.on("--scenarios x,y,z", Array, "The list feature files to include in the suite") do |scenarios|
        options.scenarios = scenarios
      end

      # Accept list of projects to include
      opts.on("--projects x,y,z", Array, "The list of projects to include in the suite") do |projects|
        options.projects = projects
      end

      # List all the projects in test map file
      opts.on("--list-projects", "--[no-]list-projects", "List projects") do |op|
        options.list_projects = op
      end

      # List all the scenarios in test map file
      opts.on("--list-scenarios", "--[no-]list-scenarios", "List scenarios") do |op|
        options.list_scenarios = op
      end

      # List all the projects in test map file
      opts.on("--list-feature-files", "--[no-]list-feature-files", "List feature files") do |op|
        options.list_features = op
      end

      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end

    opts.parse!(args)
    options
  end
end

SuiteMapper.process_ids(ARGV)