require_relative '../spec_helper'
require_relative '../../app/method_decorators/instrumented'
describe Instrumented do
  class Food
    extend MethodDecorators

    def initialize(initial_value)
      @initial_value = initial_value
    end

    +Instrumented
    def twinky
      'twonky'
    end

    +Instrumented
    def with_args(*args)
      args.inspect
    end

    +Instrumented.new('FoodG#no') { { initial_value: @initial_value } }
    def with_custom_instrument
      'good-bye'
    end

    def additional_instrumented_payload_pairs
      {ketchup: 'yummy'}
    end
    protected :additional_instrumented_payload_pairs
  end

  before(:each) do
    @subscriptions = []
    @subscriber = ActiveSupport::Notifications.subscribe(/Food*/) do |*args|
      @subscriptions << args
    end
  end
  after(:each) do
    @subscriptions = nil
    ActiveSupport::Notifications.unsubscribe(@subscriber)
  end

  Given(:initial_value) { 10 }
  Given(:subject) { Food.new(initial_value) }

  Then('instrument name derived from class and method name') {
    expect {
      subject.twinky.should == 'twonky'
    }.to change { @subscriptions.size }.by 1

    @subscriptions[0][0].should == 'Food#twinky'
    @subscriptions[0][-1].should == {args: [], ketchup: 'yummy'}
  }

  Then('instrument with parameters') {
    args = [Object.new, Object.new]
    expect {
      subject.with_args(*args).should == "#{args.inspect}"
    }.to change { @subscriptions.size }.by 1

    @subscriptions[0][0].should == 'Food#with_args'
    @subscriptions[0][-1].should == {args: args, ketchup: 'yummy'}
  }

  Then('instrument with custom name and params') {
    expect {
      subject.with_custom_instrument.should == 'good-bye'
    }.to change { @subscriptions.size }.by 1

    @subscriptions[0][0].should == 'FoodG#no'
    @subscriptions[0][-1].should == {
      args: [], initial_value: initial_value, ketchup: 'yummy'
    }
  }
end
