# # == Schema Information
# #
# # Table name: workflow_tasks
# #
# #  created_at  :datetime         not null
# #  id          :integer          not null, primary key
# #  name        :string(255)
# #  note        :string(255)
# #  job_id      :integer
# #  status      :string(255)
# #  time_finish :datetime
# #  time_start  :datetime
# #  updated_at  :datetime         not null
# #
# require 'active_record'

# class WorkflowTask < ActiveRecord::Base
#   attr_accessible :name, :note, :status, :time_finish, :time_start
#   belongs_to :job

#   scope :active, where(status: 'active')

#   def self.active_task_names
#     active.uniq.pluck(:name)
#   end


#   def self.start(job, action_name)
#     new(:name => action_name) do |task|
#       task.job = job
#       task.status = 'active'
#       Worker.enqueue(action_name, job[:id])
#     end.save!
#   end

#   def self.resync_work_queues
#     # make sure all the queues are empty---we do this by just deleting each queue.
#     # If a worker is processing a task on a queue when we delete the queue, then the job
#     # may be executed twice. But in the expected use case for this method either the
#     # workers are paused and not taking on new jobs, or the queues are already empty.
#     Worker.clear_queues

#     # now enqueue everything in our database
#     active.find_each do |task|
#       Worker.enqueue(task[:name], task[:job_id])
#     end
#   end

#   def self.active_for_task(task_name)
#     active_list = active.where(name: task_name)

#     return active_list.collect { |tsk| tsk.job_id }
#   end

#   def self.handle_task_response(task_name, jobid, response)
#     active_task = active.where(name: task_name, job_id: jobid).first

#     active_task.update_with_response(response) unless active_task.nil?
#   end

#   def update_with_response(response)
#     # 1) update job state with response
#     # 2) then remove from this queue
#     job.handle_response(response)

#     self.status = "completed"
#     self.note = response.to_s
#     self.time_finish = Time::now
#     self.save
#   end

#   def cancel
#     self.status = "cancelled"
#     self.save!
#   end
# end
