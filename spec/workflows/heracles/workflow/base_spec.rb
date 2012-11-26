require 'spec_helper'

describe Heracles::Workflow::Base do
  context '.task' do
    Given(:workflow_class) {
      Class.new(Heracles::Workflow::Base)
    }
    context 'defines waiting method based on name' do
      When { workflow_class.task('missing_worker', {}) }
      Then {
        workflow_class.should(
          have_method_signature('#wait_missing_worker', 1)
        )
      }
    end
  end

  context 'concrete workflow instance' do
    Given(:workflow_class) { Heracles::Workflow::ComplicatedMock }

    Given(:workflow) { workflow_class.new }
    Then {
      workflow.start.should == {
        next_state: :wait_get_a,
        add_to_queue: :get_a
      }
    }

    Then('transition with explicit message') {
      workflow.transition(:wait_get_a, :ok).should == {
        next_state: :wait_do_b,
        add_to_queue: :do_b
      }
    }

    Then('otherwise works') {
      workflow.transition(:wait_get_a, :some_wierd_message).should == {
        next_state: :wait_request_help,
        add_to_queue: :request_help
      }
    }

    Then('unrecognized response fails') {
      workflow.transition(:wait_request_help, :some_wierd_message).should == {
        next_state: :fail
      }
    }

    Then('done works') {
      workflow.transition(:wait_do_b, :ok).should == {
        next_state: :done
      }
    }

    Then('bogus state fails') {
      workflow.transition(:what_state_is_this, :ok).should == {
        next_state: :fail
      }
    }

  end
end
