class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password

  before_save { |user| user.email = user.email.downcase }

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EM_REGEX = /\A[\w+\-.]+@[\w+\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EM_REGEX },
  					uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
end
