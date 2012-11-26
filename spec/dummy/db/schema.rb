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

ActiveRecord::Schema.define(:version => 20121126181259) do

  create_table "api_keys", :force => true do |t|
    t.string   "key"
    t.string   "name"
    t.boolean  "is_alive"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "api_keys", ["key"], :name => "index_api_keys_on_key", :unique => true

  create_table "jobs", :force => true do |t|
    t.string   "status",         :limit => 20
    t.string   "workflow_name",  :limit => 64
    t.text     "metadata"
    t.string   "workflow_state", :limit => 64
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "context_code"
    t.integer  "parent_id"
    t.text     "parameters"
    t.integer  "submitter_id"
  end

  add_index "jobs", ["context_code"], :name => "index_jobs_on_context_code"
  add_index "jobs", ["parent_id"], :name => "index_jobs_on_parent_id"
  add_index "jobs", ["submitter_id"], :name => "index_jobs_on_submitter_id"

  create_table "workflow_tasks", :force => true do |t|
    t.string   "name"
    t.datetime "time_start"
    t.datetime "time_finish"
    t.string   "status"
    t.string   "note"
    t.integer  "job_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "workflow_tasks", ["job_id"], :name => "index_workflow_tasks_on_job_id"

end
