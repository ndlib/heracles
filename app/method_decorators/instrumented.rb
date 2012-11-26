require 'method_decorators'
#
# Instrumented provides a means of decorating a method with Rails 3.X
# instrumentation.
#
# By default, the Instrumented declaration will attempt to determine the
# method name (and containing class name) for the method that is being
# Instrumented.
#
# Example
# =======
#
#   class MyClass
#     extend MethodDecorators
#     +Instrumented
#     def my_method
#       ... stuff goes here ...
#     end
#   end
class Instrumented < MethodDecorator

  def initialize(context_name = nil, &local_instrumented_payload_pairs)
    @context_name = context_name
    @local_instrumented_payload_pairs = local_instrumented_payload_pairs
  end

  def call(some_method, context, *args, &block)
    context_name = extract_context_name(context, some_method)
    params = extract_instrument_params(context, args)
    ActiveSupport::Notifications.instrument(context_name, params) {
      some_method.call(*args,&block)
    }
  end

  protected

  def extract_instrument_params(context, args)
    returning_value = { args: args }

    if @local_instrumented_payload_pairs.respond_to?(:call)
      parameterized_options = context.
        instance_exec(&@local_instrumented_payload_pairs)
      returning_value.reverse_merge!(parameterized_options)
    end
    if additional_args = context.instance_exec do
        respond_to?(:additional_instrumented_payload_pairs) &&
          additional_instrumented_payload_pairs
      end
      returning_value.reverse_merge!(additional_args)
    end
    returning_value
  end

  def extract_context_name(context, a_method)
    return @context_name unless @context_name.nil?
    if %r{\#(?<context_name>[^\#]*)\>\Z} =~ a_method.to_s
      return "#{context.class}##{context_name}"
    end
    return "#{context.class.to_s}#unidentified_method_context"
  end
end
