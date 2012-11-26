# require_relative '../spec_helper'
# require_relative '../../app/models/job'

# describe Job do
#   context 'It responds to the correct methods' do
#     Given(:job) { Job.new }
#     Then { job.should respond_to(:context_code) }
#     Then { job.should respond_to(:metadata) }
#     Then { job.should respond_to(:parent_id) }
#     Then { job.should respond_to(:fetch_parameter) }
#     Then { job.to_i.should == job.id.to_i }
#   end

#   it 'requires valid workflow_name' do
#     job = FactoryGirl.build(:job, workflow_name: 'ChunkBacon')
#     job.valid?.should == false
#     job.workflow_name = 'trivial'
#     job.valid?.should == true
#   end
#   context '#reset_job_workflow' do
#     Given(:job) { FactoryGirl.create(:job, workflow_name: 'trivial') }
#     Given(:task) { FactoryGirl.create(:workflow_task, job_id: job.id) }

#     it 'will cancel every active task belonging to this job and restart the jobs workflow' do
#       workflow_tasks = stub(Object.new).active { [task] }
#       stub(job).workflow_tasks { workflow_tasks }

#       task.status.should == "active"

#       job.reset_job_workflow

#       task.status.should == "cancelled"
#       job.status.should == "active"
#       job.workflow_state.should == :wait_always_ok
#     end
#   end

#   context '#handle_response' do
#     Given(:wf) { Workflow::Trivial }
#     Given(:job) { FactoryGirl.create(:job, workflow: wf) }

#     it 'changes status to completed when finished' do
#       mock(wf).transition(anything, :a_message) { {next_state: :done} }
#       job.handle_response(:a_message)
#       job.status.should == "completed"
#     end

#     it 'starts tasks when needed' do
#       mock(wf).transition(anything, :a_message) {
#         {next_state: :wait_a_new_task,
#           add_to_queue: :a_new_task
#       }}
#       mock(WorkflowTask).start(job, :a_new_task)

#       job.handle_response(:a_message)
#       job.status.should_not == "completed"
#     end
#   end

# end
