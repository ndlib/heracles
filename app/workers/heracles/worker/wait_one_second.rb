class Heracles::Worker::WaitOneSecond < Heracles::Worker::Base
  self.queue = :main

  def process_with_response
    sleep 1.0
    return :ok
  end
end
