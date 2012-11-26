class Heracles::Worker::SpawnNewRabbit < Heracles::Worker::Base
  @queue = :main

  delegate_to_job_parameter('prob_of_yes', 0.5)
  delegate_to_job_parameter('number_of_rabbits', 1)
  delegate_to_job_parameter('max_levels', 10)

  def process_with_response
    if max_levels.to_i > 0
      number_of_rabbits.to_i.times do
        job.spawn!('rabbit_test',
                   {number_of_rabbits: number_of_rabbits.to_i,
                    prob_yes: prob_of_yes.to_f,
                    max_levels: (max_levels.to_i - 1) })
      end
      return :ok
    else
      return :leveled_out
    end
  end

end
