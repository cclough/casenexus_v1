class Post < ActiveRecord::Base
  attr_accessible :user_id, :content, :approved

  belongs_to :user
  
  # cool code that enables post controller to get posts by certain users
  # from http://stackoverflow.com/questions/11975532/rails-get-posts-of-users-within-10km-of-a-point
  acts_as_mappable through: :user

  validates_presence_of :content, :user_id
  validates_length_of   :content, maximum: 500

  # POST SEARCH FUNCTION
  # what the hell is scoped?
  def self.search(search)
    if search
      where('content LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

end
