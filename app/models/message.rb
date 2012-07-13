class Message < ActiveRecord::Base
  attr_accessible :sender_id, :content

  belongs_to :user

  # validates :lat, presence: true
  # validates :lng, presence: true
end
