require 'securerandom'

# A key is `alive` if it is allowed to unlock the API.
# The opposite of `alive` is `dead`.

class ApiKey < ActiveRecord::Base

  has_many :jobs, foreign_key: "submitter_id", class_name: "Job"

  attr_accessible :is_alive, :name

  before_save :check_defaults

  # returns an ApiKey object if the key is alive
  # otherwise returns `nil`
  def self.get_valid_key(key)
    ApiKey.where(key: key, is_alive: true).first
  end

  private

  def check_defaults
    self.key ||= generate_key
    self.is_alive = true if self.is_alive.nil?
  end

  # per the documentation, the key is twice the length passed in
  def generate_key
    SecureRandom.hex(16)
  end
end
