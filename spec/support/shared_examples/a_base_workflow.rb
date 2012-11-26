shared_examples "a base workflow" do
  Given(:my_workflow_class) {
    klass =
    if defined?(workflow_class)
      workflow_class
    else
      described_class
    end
  }
  Then { my_workflow_class.should be_namespaced_in('Heracles::Workflow') }
  Then { my_workflow_class.should have_method_signature('.task', 2) }
  Then { my_workflow_class.should have_method_signature('.first_task',1) }
  Then { my_workflow_class.should have_method_signature('#transition',2) }
  Then { my_workflow_class.should have_method_signature('#decode_response',2) }
  Then { my_workflow_class.should have_method_signature('.initial_state',0) }
  Then { my_workflow_class.should have_method_signature('#initial_state',0) }
end
