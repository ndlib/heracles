module Heracles::Workflow
  # The workflow module implements a DSL to describe sequential workflows.
  #
  # The DSL presents a simple model where each state is waiting for a task to
  # finish, and tasks are enqueued on transitions between states.
  #
  # Usage:
  #
  # The statement
  #
  #   first_task :task_name
  #
  # gives the first task the workflow should do. The line
  #
  #  task :task_name, {ok: :next_task}
  #
  # describes what to do when the task :task_name finishes. If the response
  # is :ok then the next task to execute is :next_task. The response may be
  # any ruby symbol. If the response does not match anything listed, the
  # workflow will finish by transition to the state :fail.
  # (TODO: revisit this policy. It may be better to ignore bad messages?)
  # A task entry may list as many responses as it would like. For example,
  #
  #   task :task_name, {
  #        ok: :next_task,
  #        too_big: :request_smaller_file,
  #        otherwise: :get_help
  #        }
  #
  # This entry says that on the response :ok the workflow should next do
  # :next_task. A response of :too_big will trigger a request for a
  # smaller file. As a special case, the `:otherwise` label will match any response
  # not matched by the other entries.
  #
  # Interface: A class represents a single workflow. The initial state is
  # 'start'. Each state is represented by a method, which is called with a
  # parameter giving the response from a worker task. Using the response only,
  # the method then returns the next state to be in the states :done and :fail
  # are special, representing a successful completion of the workflow, and a
  # non-successful completion of the workflow, respectively. The method may also
  # specify tasks to enqueue the job with by calling :add_to_queue. The usual
  # interface to the states is via the function 'transition' which ensures the
  # current state exists, and then does the dispatching.
  #
  # Some ideas for future work:
  #   * have fail return a string describing the failure
  #   * allow for parallel tasks to be done
  #   * allow for composition of state diagrams
  #
  # (For return messages, perhaps [:fail, "timeout"]
  class Base

    def self.task(name, responses)
      state_name = "wait_#{name}".to_sym
      define_method state_name do |r|
        decode_response(responses, r)
      end
    end

    def self.first_task(name)
      state_name = "wait_#{name}".to_sym
      define_method :start do |*params|
        return {next_state: state_name, add_to_queue: name}
      end
    end

    def transition(current_state, response)
      current_state = current_state.to_sym
      if self.respond_to? current_state
        send(current_state, response.to_sym)
      else
        return {next_state: :fail}
      end
    end

    def decode_response(table, r)
      next_task = table[r] || table[:otherwise] || :fail

      case next_task
      when :fail, :done
        return {next_state: next_task}
      else
        next_state_name = "wait_#{next_task}".to_sym
        return {next_state: next_state_name, add_to_queue: next_task}
      end

    end
    def self.initial_state
      :start
    end
    def initial_state
      self.class.initial_state
    end
  end
end
