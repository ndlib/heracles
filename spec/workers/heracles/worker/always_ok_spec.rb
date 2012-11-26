require 'spec_helper'

describe Heracles::Worker::AlwaysOk do
  include Heracles::WorkerWithMockedJobHelper
  Given(:worker_class) { Heracles::Worker::AlwaysOk }
  it_behaves_like 'a base worker'

  context 'an instance' do
    Given(:worker) { worker_with_mocked_job(worker_class) }
    Then { worker.process_with_response.should == :ok }
  end
end
