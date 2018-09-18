class Url < ApplicationRecord
  validates_uniqueness_of :url
  before_save :default_values

  def default_values
    self.grabbed ||= false
  end
end
