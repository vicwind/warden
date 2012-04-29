class CreateWardenProjects < ActiveRecord::Migration
  def change
    create_table :warden_projects do |t|
      t.string :name, :null => false
      t.string :project_type, :null => false, :default => "cucumber/capybara"

      t.timestamps
    end
  end
end
