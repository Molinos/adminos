class Feedback < ActiveRecord::Base

  scope :sorted, -> { order('created_at DESC') }

  validates :name, :message, presence: true
end
