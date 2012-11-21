FactoryGirl.define do
  factory :workflow_task do
    sequence(:name) {|n| "Name #{n}"}
    status 'active'
    association :job
  end
end
