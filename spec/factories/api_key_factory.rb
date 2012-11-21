FactoryGirl.define do
  factory :api_key do
    sequence(:name) {|n| "Name #{n}"}
    is_alive true
  end
end
