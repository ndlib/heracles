# Read about factories at https://github.com/thoughtbot/factory_girl

require 'common_repository_model/area'
FactoryGirl.define do
  factory :area, class: CommonRepositoryModel::Area do
    sequence(:name) { |n| "Area #{n}" }
    to_create { |instance| instance.send(:save!) }
  end
  factory :book do
    sequence(:title) {|n| "Title #{n}"}
    area { build(:area) }
   end
end
