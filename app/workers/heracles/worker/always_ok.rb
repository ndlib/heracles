class Heracles::Worker::AlwaysOk < Heracles::Worker::Base
  self.queue = :main

  def process_with_response
    :ok
  end
end