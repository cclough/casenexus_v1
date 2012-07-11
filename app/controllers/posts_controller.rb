class PostsController < ApplicationController
  before_filter :signed_in_user
  
  def index
    @posts = Post.all
  end

  def create
    @post = current_user.posts.build(params[:post])
    if @post.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

end