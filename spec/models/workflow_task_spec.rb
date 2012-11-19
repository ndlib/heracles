# == Schema Information
#
# Table name: workflow_tasks
#
#  created_at  :datetime         not null
#  id          :integer          not null, primary key
#  name        :string(255)
#  note        :string(255)
#  job_id      :integer
#  status      :string(255)
#  time_finish :datetime
#  time_start  :datetime
#  updated_at  :datetime         not null
#

require_relative '../spec_helper'

describe WorkflowTask do
  context '.active' do
    Given(:active_scope) { WorkflowTask.active }
    Then { active_scope.where_values_hash.should == {status: 'active'} }
  end

  context '.active_task_names' do
    Given(:active_task_name) { WorkflowTask.active_task_names }
    Then { active_task_name.should == [] }
  end

  context '.resync_work_queues' do
    When {
      task = FactoryGirl.create(:workflow_task,
                                name: 'dummy',
                                job_id: 1,
                                status: 'active')
      mock(Worker).clear_queues
      mock(Worker).enqueue('dummy', 1)
      WorkflowTask.resync_work_queues
    }
    Then {}
  end

  context '.active_for_task' do
    Given(:task) { FactoryGirl.create(:workflow_task,
                                      name: 'dummy',
                                      status: 'active') }
    When {
      task
    }
    Then {
      WorkflowTask.active_for_task('dummy').should include(task.job_id)
    }
  end

  context '.handle_task_response' do
    Given(:job) { FactoryGirl.create(:job) }
    Given(:task) { FactoryGirl.create(:workflow_task,
                                name: 'dummy',
                                job_id: job.id,
                                status: 'active') }
    When {
      WorkflowTask.handle_task_response('dummy', job.id, :ok)
      task.reload
    }
    Then {
      task.status = "completed"
    }
  end

  context '#update_with_response' do
    Given(:task) { FactoryGirl.create(:workflow_task) }
    When { 
      mock(task.job).handle_response(:ok)
      task.update_with_response(:ok)
    }
    Then {
      task.status.should == "completed" 
      task.note.should == "ok"
    }
  end

  context '#cancel' do
    Given(:task) { WorkflowTask.new }
    When {
      task.cancel
    }
    Then { task.status.should == "cancelled" }
  end
end
