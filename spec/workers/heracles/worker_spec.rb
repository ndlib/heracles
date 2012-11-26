require 'spec_helper'

describe Heracles::Worker do
  class Heracles::Worker::Cheese < Heracles::Worker::Base
    self.queue = :cheesy
  end
  context '.enqueue' do
    context 'with valid worker name' do
      Given(:action_name) { 'cheese' }
      Given(:job_id) { 1 }
      When { Heracles::Worker.enqueue(action_name, job_id) }

      Then { Heracles::Worker::Cheese.should have_queued(job_id).in(:cheesy) }
    end
    context 'with **invalid** worker name' do
      Given(:action_name) { 'bacon' }
      Given(:job_id) { 1 }
      Then { lambda { Heracles::Worker.enqueue(action_name, job_id) }.should(
               raise_error(Heracles::Worker::NotFoundError, /#{action_name}/)
             )
             }
    end
  end
end
