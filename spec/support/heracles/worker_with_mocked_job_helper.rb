module Heracles::WorkerWithMockedJobHelper
  module_function
  def worker_with_mocked_job(worker_class)
    job = Heracles::Job.new
    job_id = 1
    yield(job) if block_given?
    mock(Heracles::Job).find(job_id).returns(job).times(any_times)
    worker_class.new(job_id)
  end
end
