require 'spec_helper'

describe Heracles::Worker::AlwaysOk do
  include Heracles::WorkerWithMockedJobHelper
  Given(:worker_class) { Heracles::Worker::AlwaysOk }
  it_behaves_like 'a base worker'

  context 'an instance' do
    Given(:worker) { worker_with_mocked_job(worker_class) }
    Then { worker.process_with_response.should == :ok }
  end

  context 'integration specs', redis: true, slow: true do
    after(:each) do
      ResqueSpec.inline = false
    end
    context '#process_with_response' do
      Given(:job) { FactoryGirl.create(:heracles_job) }
      Given(:workflow_task) {
        FactoryGirl.create(:heracles_workflow_task,
                           name: 'always_ok',
                           job: job
                           )
      }
      Given(:worker) { Heracles::Worker::AlwaysOk.new(workflow_task.job_id) }
      Then { worker.process_with_response.should == :ok }
    end

    context '.perform', redis: true, slow: true do
      Given(:job) { FactoryGirl.create(:heracles_job) }
      Given(:workflow_task) {
        FactoryGirl.create(:heracles_workflow_task,
                           name: 'always_ok',
                           job: job
                           )
      }

      When {
        with_resque {
          Heracles::Worker::AlwaysOk.perform(workflow_task.job_id)
        }
      }
      pending "These tests need to be looked at" do
        Then { workflow_task.reload.status.should == 'completed' }
        Then { job.reload.status.should == 'completed' }
      end

    end
  end
end
