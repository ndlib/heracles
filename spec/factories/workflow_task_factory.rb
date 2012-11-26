# == Schema Information
#
# Table name: workflow_tasks
#
#  created_at  :datetime         not null
#  id          :integer          not null, primary key
#  name        :string(255)
#  note        :string(255)
#  job_id      :integer
#  status      :string(255)
#  time_finish :datetime
#  time_start  :datetime
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :heracles_workflow_task, class: Heracles::WorkflowTask do
    sequence(:name) {|n| "Name #{n}"}
    status 'active'
    association :job, factory: :heracles_job
  end
end
