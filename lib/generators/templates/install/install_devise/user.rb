require 'role_model'

class User < ApplicationRecord
  include RoleModel

  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :validatable, :omniauthable

  # has_many :authentications, dependent: :destroy

  roles :admin
  scoped_search on: :email

  def reasonable_name
    email
  end

  def translated_roles
    role_symbols.map { |s| self.class.human_attribute_name(s) }.join ', '
  end
end
