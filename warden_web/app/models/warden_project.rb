class WardenProject < ActiveRecord::Base
  attr_accessible :name, :project_type
  has_many :test_cases

  #use class instance variables in place of class variable
  class << self
    def projects_path
      @projects_path = @projects_path || "#{ENV['WARDEN_HOME']}/projects"
    end
  end

  def self.get_all_suite_file_paths
    projects_path = WardenProject.projects_path
    Dir.glob("#{projects_path}/**/*.suite") #get all the suite files in all projects
  end

end
