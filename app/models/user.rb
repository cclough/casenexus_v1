class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, 
                  :lat, :lng, :country, :city, 
                  :email_admin,:email_users, :skill, 
                  :skype, :linkedin, :num,
                  :education1, :education2, :education3,
                  :experience1, :experience2, :experience3,
                  :education1_from, :education1_to,
                  :education2_from, :education2_to,
                  :education3_from, :education3_to,
                  :experience1_from, :experience1_to,
                  :experience2_from, :experience2_to,
                  :experience3_from, :experience3_to,

  has_secure_password

  # ties to geokit gem
  acts_as_mappable :default_units => :kms,
                   :default_formula => :flat,
                   :distance_field_name => :distance,
                   :lat_column_name => :lat,
                   :lng_column_name => :lng

  # posessions
  has_many :posts
  has_many :cases
  has_many :notifications

  # session stuff
  before_save { |user| user.email = user.email.downcase }
  before_save :create_remember_token


  ####### validate data
  validates :name, presence: true, length: { maximum: 50 }
  # valid email format?
  VALID_EM_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EM_REGEX },
  					uniqueness: { case_sensitive: false } 
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true 
  validates :lat, presence: true
  validates :lng, presence: true
  validates :country, presence: true
  validates :city, presence: true
  # all other fields not required


  # function called above to create session remember token
  private

  	def create_remember_token
  		self.remember_token = SecureRandom.urlsafe_base64
  	end
end
