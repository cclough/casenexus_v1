class Notification < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :user

  validates_presence_of :content, :user_id
  validates_presence_of :content, :sender_id
  validates_presence_of :content, :type
  validates_length_of   :content, maximum: 500

end
