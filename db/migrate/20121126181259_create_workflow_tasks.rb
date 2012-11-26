class CreateWorkflowTasks < ActiveRecord::Migration
  def change
    create_table "heracles_workflow_tasks" do |t|
      t.string   "name"
      t.datetime "time_start"
      t.datetime "time_finish"
      t.string   "status"
      t.string   "note"
      t.integer  "job_id"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end

    add_index "heracles_workflow_tasks", ["job_id"]
  end
end
