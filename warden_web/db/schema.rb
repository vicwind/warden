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

ActiveRecord::Schema.define(:version => 20130109224211) do

  create_table "test_case_run_infos", :force => true do |t|
    t.string   "status",               :null => false
    t.integer  "test_case_id",         :null => false
    t.integer  "test_run_job_id",      :null => false
    t.integer  "test_run_history_id",  :null => false
    t.string   "tags"
    t.text     "test_case_log"
    t.text     "external_data"
    t.integer  "number_of_steps"
    t.datetime "end_at"
    t.datetime "start_at"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.text     "screen_capture_links"
  end

  add_index "test_case_run_infos", ["created_at"], :name => "index_test_case_run_infos_on_created_at"
  add_index "test_case_run_infos", ["end_at"], :name => "index_test_case_run_infos_on_end_at"
  add_index "test_case_run_infos", ["number_of_steps"], :name => "index_test_case_run_infos_on_number_of_steps"
  add_index "test_case_run_infos", ["start_at"], :name => "index_test_case_run_infos_on_start_at"
  add_index "test_case_run_infos", ["status"], :name => "index_test_case_run_infos_on_status"
  add_index "test_case_run_infos", ["tags"], :name => "index_test_case_run_infos_on_tags"
  add_index "test_case_run_infos", ["test_case_id"], :name => "index_test_case_run_infos_on_test_case_id"
  add_index "test_case_run_infos", ["test_run_history_id"], :name => "index_test_case_run_infos_on_test_run_history_id"
  add_index "test_case_run_infos", ["test_run_job_id"], :name => "index_test_case_run_infos_on_test_run_job_id"
  add_index "test_case_run_infos", ["updated_at"], :name => "index_test_case_run_infos_on_updated_at"

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

  add_index "test_cases", ["created_at"], :name => "index_test_cases_on_created_at"
  add_index "test_cases", ["feature_file_path"], :name => "index_test_cases_on_feature_file_path"
  add_index "test_cases", ["feature_name"], :name => "index_test_cases_on_feature_name"
  add_index "test_cases", ["last_run_at"], :name => "index_test_cases_on_last_run_at"
  add_index "test_cases", ["name"], :name => "index_test_cases_on_name"
  add_index "test_cases", ["register_at"], :name => "index_test_cases_on_register_at"
  add_index "test_cases", ["tc_id"], :name => "index_test_cases_on_tc_id"
  add_index "test_cases", ["updated_at"], :name => "index_test_cases_on_updated_at"
  add_index "test_cases", ["warden_project_id"], :name => "index_test_cases_on_warden_project_id"

  create_table "test_run_histories", :force => true do |t|
    t.integer  "run_sequence", :default => 0
    t.boolean  "is_last_run"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "test_run_histories", ["is_last_run"], :name => "index_test_run_histories_on_is_last_run"
  add_index "test_run_histories", ["run_sequence"], :name => "index_test_run_histories_on_run_sequence"

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

  add_index "test_run_jobs", ["app_environment"], :name => "index_test_run_jobs_on_app_environment"
  add_index "test_run_jobs", ["created_at"], :name => "index_test_run_jobs_on_created_at"
  add_index "test_run_jobs", ["job_type"], :name => "index_test_run_jobs_on_job_type"
  add_index "test_run_jobs", ["name"], :name => "index_test_run_jobs_on_name"
  add_index "test_run_jobs", ["queue_name"], :name => "index_test_run_jobs_on_queue_name"
  add_index "test_run_jobs", ["run_node"], :name => "index_test_run_jobs_on_run_node"
  add_index "test_run_jobs", ["schedule_at"], :name => "index_test_run_jobs_on_schedule_at"
  add_index "test_run_jobs", ["schedule_by"], :name => "index_test_run_jobs_on_schedule_by"
  add_index "test_run_jobs", ["start_at"], :name => "index_test_run_jobs_on_start_at"
  add_index "test_run_jobs", ["status"], :name => "index_test_run_jobs_on_status"
  add_index "test_run_jobs", ["updated_at"], :name => "index_test_run_jobs_on_updated_at"

  create_table "warden_projects", :force => true do |t|
    t.string   "name",                                          :null => false
    t.string   "project_type", :default => "cucumber/capybara", :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "warden_projects", ["created_at"], :name => "index_warden_projects_on_created_at"
  add_index "warden_projects", ["name"], :name => "index_warden_projects_on_name"
  add_index "warden_projects", ["project_type"], :name => "index_warden_projects_on_project_type"
  add_index "warden_projects", ["updated_at"], :name => "index_warden_projects_on_updated_at"

end
