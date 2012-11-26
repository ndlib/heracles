require 'method_decorators'
#
# The PostCondition method decorator provides a means of defining and enforcing
# the returned value(s) of a method call.
#
# Example
# =======
#
#   class MyClass
#     extend MethodDecorators
#     +PostCondition.new {|returned| returned.is_a?(Symbol) }
#     def my_method
#       ... stuff goes here ...
#     end
#   end
class PostCondition < MethodDecorator
  class FailedCondition < ArgumentError
    def initialize(context, a_method, message)
      message_prefix = context.to_s
      if %r{\: (?<context_name>.*)\>} =~ a_method.to_s
        message_prefix = context_name
      end
      super( "#{message_prefix}:post_condition(#{message.inspect})" )
    end
  end

  def initialize(message = 'failed', &post_condition_block)
    @message = message
    @post_condition_block = post_condition_block
  end

  def call(orig, this, *args, &block)
    returning_value = orig.call(*args, &block)
    unless passes?(this, *returning_value)
      raise FailedCondition.new(this, orig, @message)
    end
    returning_value
  end

  protected
  def passes?(context, *args)
    context.instance_exec(*args, &@post_condition_block)
  end
end
