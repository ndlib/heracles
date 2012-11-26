require 'spec_helper'

describe Heracles::Workflow do
  context '.factory' do
    Given(:workflow_name) { 'trivial'}
    Then{
      Heracles::Workflow.factory(workflow_name).should be_an_kind_of(Heracles::Workflow::Base)
    }
  end
  context '.find_by_workflow_name' do
    context 'valid name' do
      Given(:workflow_name) { 'trivial' }
      Then {
        Heracles::Workflow.find_by_workflow_name(workflow_name).should ==
        Heracles::Workflow::Trivial
      }
    end
    context 'base is not valid' do
      Given(:workflow_name) { 'base' }
      Then {
        lambda {
          Heracles::Workflow.find_by_workflow_name(workflow_name)
        }.should raise_error Heracles::Workflow::NotFoundError
      }
    end
    context 'invalid name' do
      Given(:workflow_name) { 'no-way-this-exists' }
      Then {
        lambda {
          Heracles::Workflow.find_by_workflow_name(workflow_name)
        }.should raise_error Heracles::Workflow::NotFoundError
      }
    end
  end

  context '.names' do
    Then { Heracles::Workflow.names.should include('trivial')}
    Then { Heracles::Workflow.names.should_not include('base')}
    Then { Heracles::Workflow.names.should_not include('not_found_error')}
  end
end
