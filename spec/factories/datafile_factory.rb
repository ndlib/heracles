# == Schema Information
#
# Table name: datafiles
#
#  attachment :string(255)
#  contents   :binary
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  name       :string(255)
#  job_id     :integer
#  updated_at :datetime         not null
#


FactoryGirl.define do
  factory :datafile do
    association :job
  end
end
