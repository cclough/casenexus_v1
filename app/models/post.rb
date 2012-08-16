class Post < ActiveRecord::Base
  attr_accessible :user_id, :content, :approved

  belongs_to :user

  validates_presence_of :content, :user_id
  validates_length_of   :content, maximum: 140


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
