#############################################################################
#  Gerbil class: (This class is NOT process or thread safe)
#  Purpose: to be able to create a basic hierarchy of temp .feature/.rb
#           files for variation of project instances. Extracts only parent
#           files so that children's .feature/.rb are used for differences
#           across instances.
#############################################################################
# External considerations
#############################################################################
#
# Zip file construction:
#   *
#   ** (any file or dir will be included)
#	  Version.yaml
#
# Version.yaml contents:
#	Project: "Project Name"
#	Version: "Version of zip file"
#	Release: "Release date of zip file"
#	Signer:  "Person responsible for making zip file"
#
#############################################################################

class Gerbil
  require 'zip/zip'
  require 'yaml'
  require 'fileutils'
  require 'digest/md5'
  require 'curb'

  attr_accessor :base_tmp_dir

	VALIDATION_URL = "http://qatest:ir0nhorse@ec2-174-129-171-140.compute-1.amazonaws.com/zip_validate.yaml"
		
	# Takes in a parent location or a zip file.
	# outputs the files not located in the child directory
	# to a temp directory
	
	# This assumes that the Project Directory is given for the child project
	# it will automatically add a /features to the end of string so that it will only look in the
	# features folder
	
  def initialize()
    @base_tmp_dir = "/tmp/gerbil"
  end

	def gerbilnate(parent_dir, child_dir)
	
	  # Project Name assumption
    if( ! child_dir.include?("/features") )
	    child_dir = "#{child_dir}/features"
	  end
	
  	# Make directory to store the parent .feature and .rb files
    tmpdir = "#{@base_tmp_dir}/#{File.basename(parent_dir).gsub('.zip','')}_#{Process.pid}"
    @tmpdir = tmpdir
  	cleanup(tmpdir)

  	FileUtils::mkdir_p(tmpdir)
	
		# check to see if zip
		if ( parent_compressed?(parent_dir)	) 
			# extract files only if they don't exist in the child directory	  
      Zip::ZipInputStream::open(parent_dir) {
        |io|
        while (entry = io.get_next_entry)
          if ( !File.exists?("#{child_dir}/#{entry.name}") or
              entry.name_is_directory? )
              #puts "Contents of #{entry.name}: '#{io.read}'"             
              if entry.name_is_directory?
                FileUtils::mkdir_p("#{tmpdir}/#{entry.name}")
              else
                File.open( "#{tmpdir}/#{entry.name}", 'w' ) {|f| f.write(io.read) }
              end
          else
            puts "File #{entry.name} not extracted because it exists in child directory"
          end        
        end
      }				  				  
		else
		  # For each file that exists in the parent directory, check to see if it exists in the child
		  # directory. If not, copy from parent folder to the temp directory
		  Dir["#{parent_dir}/**/*"].each { |file|
        file_base_name = File.basename(file)
        if File.directory?(file)
          FileUtils::mkdir_p("#{tmpdir}/#{file_base_name}")
        else
          if ( ! File.exists?("#{child_dir}/#{file_base_name}") )
            FileUtils::cp("#{file}","#{tmpdir}/#{file.sub(parent_dir,'')}")
          end
        end
		  }
		end
    @tmpdir
	end
	
	# Validation mechanism for 'signing' zip files	
  # This requires the full path to the zipfile

	def zip_validates?(zipfile)
		#go to the validation site
		#validate that zip file md5 matches site's record of zip file

    project_info = load_project_details(zipfile)
    
    c = Curl::Easy.new(VALIDATION_URL) do |curl|
      curl.max_redirects   = 3
      curl.enable_cookies  = true
      curl.follow_location = true
      curl.perform
    end
    
    releases = YAML::load( c.body_str )
    
    #stop processing if the release doesn't exist    
    if ( releases.has_value?( project_info["Version"] ) )
      return false
    end
    
    #MD5 of zipfile
    zip_md5 = Digest::MD5.file(zipfile)
    
    #MD5 listed on validation site
    valid_md5 = releases[ project_info["Version"] ]

    if ( "#{zip_md5}" != "#{valid_md5}" )
      return false
    end
        
    return true
    
	end
	
	# Helper method for grabbing the Version.yaml details
	def load_project_details(zipfile)
			project_info = ""

  		Zip::ZipFile.open(zipfile, Zip::ZipFile::CREATE) {
  		  |zipfile|
  		  project_info = YAML::load( zipfile.read("Version.yaml") )
  		}  		
      return project_info
	end	
	
	# Helper method for checking if the parent directory is a zip file
	# NOTE: This is NOT very smart. It just looks for the .zip extension
	
	def parent_compressed?(parent_dir)
	  File.basename(parent_dir).include?(".zip") ? true : false
	end
	
	
	# validation mechanism for verifying project names match
	# can be used to provide debug output
	
	# Check to see if the version.yaml Project name matches
	# the current_project variable. returns true/false
	# If a zip file is not passed in, then it assumes a location
	# grabs the basename of the folder and validates the current_project
	# variable against that.
	
	def project_safe?(parent_dir, current_project)		
		project_info = ""

		if parent_compressed?(parent_dir)

      project_info = load_project_details(parent_dir)

  		if project_info["Project"] == current_project
  		  return true
  		end

	  else
      if( File.basename(parent_dir) == current_project )
        return true
	    end
	  end
	  
		return false
	end
	
	# Clean up the gerbil mess. They like to chew on things you know...
	# remove gerbil destination folder and contents
	# need to remove the :noop and :verbose once testing is finished
	def cleanup(dir)
		if ( FileTest::directory?(dir) )
	      FileUtils.rm_rf dir
	  end
  end

  def cleanup_tmp_dir
     cleanup(@base_tmp_dir) if @base_tmp_dir
  end

  def cleanup_last_directory
    cleanup(@tmpdir)
  end
  
end
