# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120416060756) do

  create_table "test_case_run_infos", :force => true do |t|
    t.datetime "start_at",            :null => false
    t.string   "status",              :null => false
    t.string   "tags",                :null => false
    t.text     "external_data",       :null => false
    t.text     "test_case_log",       :null => false
    t.datetime "end_at",              :null => false
    t.integer  "number_of_steps",     :null => false
    t.integer  "test_case_id",        :null => false
    t.integer  "test_run_job_id",     :null => false
    t.integer  "test_run_history_id", :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "test_cases", :force => true do |t|
    t.string   "name",              :null => false
    t.string   "feature_name",      :null => false
    t.string   "feature_file_path", :null => false
    t.datetime "register_at",       :null => false
    t.integer  "tc_id",             :null => false
    t.integer  "warden_project_id", :null => false
    t.datetime "last_run_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "test_run_histories", :force => true do |t|
    t.integer  "run_sequence", :default => 0
    t.boolean  "is_last_run"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "test_run_jobs", :force => true do |t|
    t.string   "name",            :null => false
    t.datetime "schedule_at",     :null => false
    t.string   "schedule_by",     :null => false
    t.string   "status",          :null => false
    t.string   "job_type",        :null => false
    t.string   "run_node",        :null => false
    t.string   "queue_name",      :null => false
    t.string   "app_environment", :null => false
    t.datetime "start_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "warden_projects", :force => true do |t|
    t.string   "name",                                          :null => false
    t.string   "project_type", :default => "cucumber/capybara", :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

end
