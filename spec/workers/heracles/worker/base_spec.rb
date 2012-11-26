require 'spec_helper'

describe Heracles::Worker::Base do
  include Heracles::WorkerWithMockedJobHelper
  Given(:worker_class) do
    Class.new(Heracles::Worker::Base) do
      def self.to_s
        'Heracles::Worker::Base'
      end

      def logged_method
        log('baz') { 'hello' }
      end

      delegate_to_job_parameter('key')
      delegate_to_job_parameter('key_with_default_value', 2)
      delegate_to_job_parameter('missing_key')
      delegate_to_job_parameter('missing_key_with_default_value', 3)
    end
  end

  it_behaves_like "a base worker"

  Given(:worker) { worker_with_mocked_job(worker_class) }

  Then { worker.should delegate(:job_id).to(:job).via(:id) }
  Then { worker.should delegate(:job_status).to(:job).via(:status) }

  context '#log' do
    When {
      mock(ActiveSupport::Notifications).instrument(
        "worker#logged_method",
        worker_name: worker.task_name,
        job_id: worker.job_id,
        message: 'baz',
        line_number: '12'
      )
    }
    Then { worker.logged_method }
  end

  context '#serialize_to_job_parameter' do
    Given(:key) { 'key' }
    Given(:value) { 'value' }
    When { mock(worker.job).serialize_parameter!(key, value)}
    Then { worker.send(:serialize_to_job_parameter, key, value) }
  end

  context '.delegate_to_job_parameter' do
    Given(:worker) do
      worker_with_mocked_job(worker_class) do |job|
        job.parameters = {key: 'a', key_with_default_value: 'b'}
      end
    end
    Then { worker.key.should == 'a' }
    Then { worker.key_with_default_value.should == 'b' }
    Then { lambda { worker.missing_key }.should(
             raise_error(
               Heracles::Worker::InvalidParameterization,
               /\"missing_key\"/i
             )
    )}
    Then { worker.missing_key_with_default_value.should == 3 }
  end

  context '#process_with_response' do
    Then {
      expect {
        worker.process_with_response
      }.to(raise_error RuntimeError, /\#process_with_response/)
    }
  end
  context '#__perform__' do
    Then {
      mock(worker).process_with_response.returns(:called_process_with_response)
      mock(Heracles::WorkflowTask).handle_task_response(
        worker.task_name,
        worker.job_id,
        :called_process_with_response
      )
      worker.__perform__
    }
  end
end
