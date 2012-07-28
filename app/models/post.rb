class Post < ActiveRecord::Base
  attr_accessible :user_id, :content

  belongs_to :user

  validates_presence_of :content, :user_id
  validates_length_of   :content, maximum: 140
  # default_scope order: 'created_at DESC'

  # post search class
  def self.search(search)
    if search
      where('content LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

end
