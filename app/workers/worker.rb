module Worker
  class NotFoundError < NameError
  end

  class InvalidParameterization < RuntimeError
    def initialize(object_with_id, parameterized_method, exception)
      message = "Unable to derive #{parameterized_method.to_s.inspect}"
      message << " from #{object_with_id.class} ID=#{object_with_id[:id]}"
      message << "\nWith Original Exception: #{exception.class} #{exception}"
      super(message)
    end
  end

  module_function

  def clear_queues
    Resque.queues.each {|queue| Resque.remove_queue(queue) }
  end

  def enqueue(name, job_id)
    ActiveSupport::Notifications.instrument(
      "worker#enqueue",
      worker_name: name,
      job_id: job_id
    ) do
      Resque.enqueue(worker_class_for(name), job_id)
    end
  end

  def worker_class_for(name)
    constant_to_lookup = name.to_s.camelize
    const_get(constant_to_lookup)
  rescue NameError
    raise NotFoundError.new(
      "Worker for name #{name.inspect} not found.
      Define #{self}::#{constant_to_lookup}"
    )
  end
end

Dir[File.join(File.dirname(__FILE__),"workers/**/*.rb")].each {|f| require f}
