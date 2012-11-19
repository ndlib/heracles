require_relative '../spec_helper_integration'

describe Job do
  Given(:job) {FactoryGirl.create(:job, parameters: parameters)}
  Given(:parameters) { {hello: 'world', key: 'other_value'} }
  Given(:key) { 'key' }

  context '#handle_response', slow: true do
    before(:all) do
      @trivial_job = FactoryGirl.create(:job, workflow_state: 'wait_always_ok')
    end

    When { @trivial_job.handle_response(:ok) }
    Then { @trivial_job.reload.status.should == 'completed'
           @trivial_job.workflow_state.should == 'done' }

  end
  context '#fetch_parameter', slow: true do
    Then { job.fetch_parameter('hello').should == 'world' }

    Then {
      expect {
        job.fetch_parameter('missing')
      }.to(raise_error(KeyError))
    }
  end
  context '#serialize_parameter!', slow: true do
    Given(:value) { 'value' }
    When { job.serialize_parameter!(key, value) }
    Then('updates serialized key/value pair') {
      job.reload.fetch_parameter(key).should == value
    }
    Then('does not update/destroy other keys') {
      job.reload.fetch_parameter('hello').should == 'world'
    }
  end

  context '#spawn! works', slow: true do
    Given(:job_count) {Job.count}
    Given(:child) {job.spawn!("trivial", {key: "value"})}
    When {job; job_count; child}
    Then {Job.count.should == (job_count + 1)}
    Then {child.parent_id.should == job[:id]}
    Then {child.fetch_parameter(:key).should == "value"}
    Then {child.workflow_state.should == :wait_always_ok}
    Then {child.workflow_tasks.count.should == 1}
    Then {Worker::AlwaysOk.should have_queued(child[:id]).in :main}
  end

end
