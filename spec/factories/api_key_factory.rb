FactoryGirl.define do
  factory :heracles_api_key, class: "Heracles::ApiKey" do
    sequence(:name) {|n| "Name #{n}"}
    is_alive true
  end
end
