# == Schema Information
#
# Table name: audits
#
#  action     :string(255)
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  note       :string(255)
#  job_id     :integer
#  updated_at :datetime         not null
#  user       :string(255)
#

class Audit < ActiveRecord::Base
  attr_accessible :action, :note, :user
  belongs_to :job
end
