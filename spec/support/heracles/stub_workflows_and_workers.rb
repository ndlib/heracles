class Heracles::Worker::GetA < Heracles::Worker::Base
  self.queue = :main
end

class Heracles::Worker::DoB < Heracles::Worker::Base
  self.queue = :main
end

class Heracles::Worker::DoA < Heracles::Worker::Base
  self.queue = :main
end

class Heracles::Worker::RequestHelp < Heracles::Worker::Base
  self.queue = :main
end

class Heracles::Workflow::ComplicatedMock < Heracles::Workflow::Base
  first_task :get_a
  task(
    :get_a,
    {
      ok: :do_b,
      otherwise: :request_help
    }
  )
  task :request_help, {ok: :get_a}
  task :do_b, {ok: :done}
end
