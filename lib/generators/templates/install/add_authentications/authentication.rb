class Authentication < ApplicationRecord
  belongs_to :user

  accepts_nested_attributes_for :user

  validates :uid, uniqueness: { scope: :provider }
end
