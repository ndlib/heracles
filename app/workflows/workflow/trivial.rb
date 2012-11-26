class Workflow::Trivial < Workflow::Base
  first_task :always_ok
  task :always_ok, {ok: :done}
end