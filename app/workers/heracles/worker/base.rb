require 'method_decorators/decorators'
module Heracles::Worker
  class Base
    def self.queue=(queue_name)
      @queue = queue_name
    end

    def self.perform(job_id)
      new(job_id).__perform__
    end

    def self.task_name
      to_s.demodulize.underscore
    end

    def self.delegate_to_job_parameter(key, default_value = nil)
      define_method(key.to_sym) do
        begin
          job.fetch_parameter(key)
        rescue NameError, KeyError => e
          if default_value.nil?
            raise Heracles::Worker::InvalidParameterization.new(job, key, e)
          else
            return default_value
          end
        end
      end
    end

    attr_reader :job
    def initialize(job_id)
      @job = Heracles::Job.find(job_id.to_i)
    end

    # Provide a unified interface for logging worker actions
    def log(message = nil, &block)
      %r{(?<line_number>\d+)\:in \`(?<method_name>[^']*)'\Z} =~ caller[0]

      payload = additional_instrumented_payload_pairs.merge(
          message: message,
          line_number: line_number
        )

      ActiveSupport::Notifications.instrument(
        "worker##{method_name}",
        payload,
        &block
      )
    end

    def serialize_to_job_parameter(key, value)
      job.serialize_parameter!(key, value)
    end

    def task_name
      self.class.task_name
    end

    def __perform__
      log do
        Heracles::WorkflowTask.handle_task_response(
          task_name,
          job_id,
          process_with_response
        )
      end
    end
    delegate :id, :status, to: :job, prefix: :job

    extend MethodDecorators
    def additional_instrumented_payload_pairs
      {
        job_id: job_id,
        worker_name: task_name
      }
    end

    # Must return a symbol
    def process_with_response
      raise RuntimeError, "Define #{self.class}#process_with_response"
    end

  end
end
