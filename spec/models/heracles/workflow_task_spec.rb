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

require 'spec_helper'

describe Heracles::WorkflowTask do
  context '.active_task_names', slow: true do
    Given(:workflow_task) { FactoryGirl.create(:heracles_workflow_task) }
    When{ workflow_task }
    Then { Heracles::WorkflowTask.active_task_names.should include(workflow_task.name) }
  end

  context '.active' do
    Given(:active_scope) { Heracles::WorkflowTask.active }
    Then { active_scope.where_values_hash.should == {status: 'active'} }
  end

  context '.resync_work_queues' do
    When {
      task = FactoryGirl.create(:heracles_workflow_task,
                                name: 'dummy',
                                job_id: 1,
                                status: 'active')
      mock(Heracles::Worker).clear_queues
      mock(Heracles::Worker).enqueue('dummy', 1)
    }
    Then {
      Heracles::WorkflowTask.resync_work_queues
    }
  end

  context '.active_for_task' do
    Given(:task) { FactoryGirl.create(:heracles_workflow_task,
                                      name: 'dummy',
                                      status: 'active') }
    When {
      task
    }
    Then {
      Heracles::WorkflowTask.active_for_task('dummy').should include(task.job_id)
    }
  end

  context '.handle_task_response' do
    Given(:job) { FactoryGirl.create(:heracles_job) }
    Given(:task) { FactoryGirl.create(:heracles_workflow_task,
                                      name: 'dummy',
                                      job_id: job.id,
                                      status: 'active') }
    When {
      Heracles::WorkflowTask.handle_task_response('dummy', job.id, :ok)
      task.reload
    }
    Then {
      task.status = "completed"
    }
  end

  context '#update_with_response' do
    Given(:task) { FactoryGirl.create(:heracles_workflow_task) }
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
    Given(:task) { Heracles::WorkflowTask.new }
    Given(:cancel_time) { Time.new(1) }
    When { stub(Time).now { cancel_time } }
    When {
      task.cancel
    }
    Then {
      task.status.should == "cancelled"
      task.time_finish.should == cancel_time
    }
  end
end
