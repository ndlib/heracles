class Heracles::Workflow::RabbitTest < Heracles::Workflow::Base
  first_task :spawn_new_rabbit
  task :spawn_new_rabbit, {ok: :get_random_yes_or_no, leveled_out: :done}
  task :get_random_yes_or_no, {yes: :wait_one_second, no: :done}
  task :wait_one_second, {ok: :spawn_new_rabbit}
end
