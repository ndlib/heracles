# == Schema Information
#
# Table name: jobs
#
#  id             :integer          not null, primary key
#  status         :string(255)
#  workflow_name  :string(255)
#  metadata       :string(255)
#  workflow_state :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  context_code   :string(255)
#  parent_id      :integer
#  parameters     :text
#

class Heracles::Job < ActiveRecord::Base
  require 'morphine'
  include Morphine

  attr_accessible(
    :metadata,
    :workflow_name,
    :parameters
  )
  serialize :parameters, Hash

  validates(
    :workflow_name,
    {
      inclusion: {
        in: lambda { |job| ::Heracles::Workflow.names },
        allow_nil: false,
        allow_blank: false,
        message: "could not be find in Workflow.names"
      }
    }
  )

  has_many :workflow_tasks, dependent: :destroy, class_name: "Heracles::WorkflowTask"
  belongs_to :submitter, class_name: "Heracles::ApiKey"

  def self.serialization_for_active_workflow(workflow_name)
    active_list = where(workflow_name: workflow_name, status: 'active')
    active_list.collect! { |s| {id: s[:id], workflow_state: s.workflow_state} }

    { workflow: {
        name: workflow_name,
        status: 'active',
        jobs: active_list
      }
      }
  end

  def self.create_and_start_workflow(attributes)
    new(attributes) do |job|
      yield job if block_given?
      job.start_workflow
    end
  end

  def start_workflow(new_workflow_name=nil)
    self.workflow_name = new_workflow_name || self.workflow_name
    return false if !valid?
    self.workflow_state = workflow.initial_state
    self.status = 'active'
    self.save!
    do_initial_transition
    return true
  end

  def reset_job_workflow
    # remove from any pending task queues...
    # and initialize in the start state...
    active_tasks = self.workflow_tasks.active

    active_tasks.each do |tsk|
      tsk.cancel
    end

    start_workflow
  end

  def do_initial_transition
    handle_response(:ok)
  end

  def handle_response(response)
    raise "Job response #{response} is not a symbol" unless response.respond_to?(:to_sym)
    transition = workflow.transition(workflow_state, response)

    if action = transition[:add_to_queue]
      Heracles::WorkflowTask.start(self, action)
    end

    self.workflow_state = transition[:next_state]
    case transition[:next_state]
    when :done, :fail
      self.status = "completed"
    end
    save!
  end

  def to_i
    self[:id].to_i
  end

  def serialize_parameter!(key,value)
    parameters[key.to_s] = value
    save!
  end

  def fetch_parameter(key)
    parameters.stringify_keys.fetch(key.to_s)
  end

  # starts a new job having this one as its parent
  # all the parameters are passed opaquely to the new job
  def spawn!(new_workflow, parameters={})
    Heracles::Job.create_and_start_workflow(
      workflow_name: new_workflow,
      parameters: parameters.stringify_keys
    ) do |child|
      child.parent_id = self[:id]
    end
  end

  def parameters=(args)
    super(args.stringify_keys)
  end

  def workflow_name=(proposed_workflow_name)
    super(proposed_workflow_name.to_s.underscore)
  end

  protected
  register :workflow do
    ::Heracles::Workflow.factory(workflow_name)
  end
end
