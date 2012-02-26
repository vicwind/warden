#############################
## Max-in Patch Cucumber:
##   Modified Cucumber's feature loading flow to include features and steps
##   that lives in a pkg location e.g. a tar.gz file.
##   This feature will help sharing features files accorss different projects
##   easier and provide a way to manage a "single source of true" for the
##   shareing features.
##############################
module Cucumber
  module Cli
    class Configuration
      alias_method :original_feature_files, :feature_files
      #alias_method :original_all_files_to_load, :all_files_to_load

      #This method is a modifed copy of the original feature_files method
      #Params:
      # pkg_paths => an array of string path name
      #Return a list of all feature file in the path
      def pkg_feature_files(pkg_paths)
        potential_feature_files = pkg_paths.map do |path|
          path = path.gsub(/\\/, '/') # In case we're on windows. Globs don't work with backslashes.
          path = path.chomp('/')
          if File.directory?(path)
            Dir["#{path}/**/*.feature"].sort
          elsif path[0..0] == '@' and # @listfile.txt
            File.file?(path[1..-1]) # listfile.txt is a file
            IO.read(path[1..-1]).split
          else
            path
          end
        end.flatten.uniq
        remove_excluded_files_from(potential_feature_files)
        potential_feature_files
      end

      def feature_files
        cli_arg_feature_files = original_feature_files()
        pkg_features_list = pkg_feature_files([@pkg_feature_path])
        if paths().size == 1 and (paths.include?("features") or
                                  paths.include?("./features/")) #when user don't spcified a list of features
          cli_arg_feature_files.reject! do |file|
            #filter out the pkg feature files
            pkg_features_list.delete(get_feature_file_path(file).sub(/:.*/,''))
          end
          pkg_features_list.map{ |f| @pkg_setup_info += "Using feature file from pkg: #{f}\n"}
          cli_arg_feature_files + pkg_features_list
        else #when uses specified a list of files
          cli_arg_feature_files.map do |file|
            #filter out the pkg feature files
            new_file =  get_feature_file_path(file)
            @pkg_setup_info += "Using feature file from pkg: #{new_file}\n" if file != new_file
            new_file
          end
        end

      end

      #Return the correct feature file path for the requested feature file
      #feature file can come from two places: 1. the pkg lib location, 2.the
      #current project's feature directory.
      #the file under the current project's feature directory alsway overwrite
      #the one in other location
      def get_feature_file_path(feature_file)
        return feature_file if feature_file == "features"
        if !feature_file.include?("/")
          pkg_location_path = "#{@pkg_feature_path}/#{feature_file}"
        else
          pkg_location_path =  feature_file.sub(/.*\//, @pkg_feature_path + "/")
        end
        File.file?(feature_file) ? feature_file : pkg_location_path
      end

      #This methods can be called in the AfterConfiguration hook
      #to load additinal features and steps files from the pkg_path
      #Params:
      # pkg_pkg => the pkg location for the feautres and steps files
      #Return: None
      def pkg_step_and_lib_files(pkg_path)
        @pkg_feature_path = pkg_path + "/features"
        @pkg_path = pkg_path
        @pkg_setup_info = ''
        feature_files() #just to populate the features file list in @pkg_setup_info
        @pkg_setup_info += "\n"
        step_defs_files_list = step_defs_to_load()
        requires = [@pkg_feature_path]
        files = requires.map do |path|
          path = path.gsub(/\\/, '/') # In case we're on windows. Globs don't work with backslashes.
          path = path.gsub(/\/$/, '') # Strip trailing slash.
          File.directory?(path) ? Dir["#{path}/**/*"] : path
        end.flatten.uniq
        remove_excluded_files_from(files)
        files.reject! {|f| !File.file?(f)}
        files.reject! {|f| File.extname(f) == '.feature' }
        files.reject! {|f| f =~ /^http/}
        files.reject! {|f| !f.match(/\.rb$/)}
        files.reject! {|f| f.include?("project_init.rb")}
        #exclude the ruby file that has the same path after the "./features/" dir
        files.reject! do |f|
          step_defs_files_list.find do |file|
            file.include?(f.sub(/^.*?\/(features)+/,''))
          end
        end
        files.sort
        files.each{ |file| @pkg_setup_info += "Loading #{file}: #{require file}\n"}
        @pkg_setup_info += "\n"
      end

      def get_pkg_setup_info
        @pkg_setup_info
      end

    end
  end
end #of Cucumber Mix-in

