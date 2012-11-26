module Heracles::Workflow
  class NotFoundError < NameError
    def initialize(base, name, constant_to_lookup)
      super("Workflow for name #{name.inspect} not found.
      Define #{base}::#{constant_to_lookup}")
    end
  end

  module_function

  def factory(workflow_name)
    find_by_workflow_name(workflow_name).new
  end

  def find_by_workflow_name(name)
    constant_to_lookup = name.to_s.classify
    if workflow_constant_names.include?(constant_to_lookup)
      begin
        const_get(constant_to_lookup)
      rescue NameError
        raise NotFoundError.new(self, name, constant_to_lookup)
      end
    else
      raise NotFoundError.new(self, name, constant_to_lookup)
    end
  end

  def names
    workflow_constant_names.
    collect(&:underscore).
    sort
  end

  def workflow_constant_names
    (constants.collect(&:to_s) - ['NotFoundError','Base'])
  end
end
Dir[File.join(File.dirname(__FILE__),"workflow/**/*.rb")].each {|f| require f}