class User < ActiveRecord::Base
  validates :full_name, presence: true
  has_secure_password
  validates :password, on: :create, length: {minimum: 6}
  validates :email, uniqueness: true
end