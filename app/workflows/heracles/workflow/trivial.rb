class Heracles::Workflow::Trivial < Heracles::Workflow::Base
  first_task :always_ok
  task :always_ok, {ok: :done}
end