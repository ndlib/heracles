class CreateJobs < ActiveRecord::Migration
  def change
    create_table "jobs" do |t|
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

    add_index "jobs", ["context_code"]
    add_index "jobs", ["parent_id"]
    add_index "jobs", ["submitter_id"]

  end
end
