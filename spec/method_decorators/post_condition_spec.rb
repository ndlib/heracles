require_relative '../../app/method_decorators/post_condition'
require 'rspec'
require 'rspec-given'

describe PostCondition do
  Given(:klass) do
    Class.new do
      extend MethodDecorators
      def initialize(integer)
        @integer = integer
      end

      +PostCondition.new('expected < 10') { |returned| returned < 10 }
      def multiply(i)
        i * @integer
      end

      +PostCondition.new{ |returned| returned.size == 2 }
      +PostCondition.new{ |returned| returned =~ /7$/ }
      def concat(a)
        "#{@integer}#{a}"
      end

      +PostCondition.new{ |r1, r2| r1.is_a?(String) && r2.is_a?(Fixnum)}
      def multi_return(a)
        return a, @integer
      end
    end
  end
  Given(:input) { 3 }
  Given(:object) { klass.new(input) }

  context 'with one post condition' do
    Then "calls the method if the post condition passes" do
      object.multiply(2).should == 6
    end

    Then "raises if the post_condition fails" do
      expect{ object.multiply(8) }.to(
        raise_error(
          PostCondition::FailedCondition,
          /multiply:post_condition\("expected \< 10"\)/
        )
      )
    end
  end

  context "with multiple post_conditions" do
    Then "calls the method if the post_condition passes" do
      object.concat(7).should == "#{input}7"
    end

    Then "raises if the post_condition fails" do
      expect{ object.concat(8) }.to raise_error(PostCondition::FailedCondition)
    end
  end

  context "with multi_return" do
    Then "calls the method if the post_condition passes" do
      object.multi_return('7').should == ['7',input]
    end

    Then "raises if the post_condition fails" do
      expect{ object.multi_return(8) }.to(
        raise_error(
          PostCondition::FailedCondition,
          /\#multi_return\:post_condition\("failed"\)/
        )
      )
    end
  end
end
