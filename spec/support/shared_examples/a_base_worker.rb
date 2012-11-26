shared_examples "a base worker" do
  let(:job_id) { 123 }
  let(:job) { Struct.new(:id,:status).new(job_id, 'hello') }
  let(:worker) {
    mock(Heracles::Job).find(job_id).returns(job)
    worker_class.new(job_id)
  }
  Then{ worker_class.should be_namespaced_in('Heracles::Worker') }
  Then{ worker_class.should have_method_signature('.perform', 1) }
  Then{ worker_class.should have_method_signature('.queue=', 1) }
  Then{ worker_class.should have_method_signature('.task_name', 0) }
  Then{ worker_class.should have_method_signature('#serialize_to_job_parameter', 2) }
  Then{ worker.should delegate(:job_id).to(:job).via(:id) }
  Then{ worker.should delegate(:job_status).to(:job).via(:status) }
  Then{
    worker_class.should(
      have_method_signature('.delegate_to_job_parameter', -2)
    )
  }
  Then{ worker_class.should have_method_signature('#initialize',1) }
end
