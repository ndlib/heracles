FactoryGirl.define do
  factory :api_key, class: "Heracles::ApiKey" do
    sequence(:name) {|n| "Name #{n}"}
    is_alive true
  end
end
