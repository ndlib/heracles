# == Schema Information
#
# Table name: jobs
#
#  id             :integer          not null, primary key
#  status         :string(255)
#  workflow_name  :string(255)
#  metadata       :string(255)
#  workflow_state :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  context_code   :string(255)
#  parent_id      :integer
#  parameters     :text
#

FactoryGirl.define do
  factory :job do
    metadata "<xml ftw='false' />"
    status 'active'
    workflow_name 'trivial'
    workflow_state 'start'
    association :submitter, :factory => :api_key
    created_at Time.now
    updated_at Time.now
  end
end
