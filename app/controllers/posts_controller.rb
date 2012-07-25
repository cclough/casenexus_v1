class PostsController < ApplicationController
  before_filter :signed_in_user
  
  def index
    @posts = Post.find(params[:country])

    respond_to do |format|
      format.html { render :layout => false }
    end  
  end

  def create

    @post = current_user.posts.build(params[:post])

    respond_to do |format|
      if @post.save
        # flash[:success] = "Micropost created!"
        format.html { redirect_to @post, notice: 'Post was successfully created.' }  
        format.js  
      else
        format.html { render action: "new" }  
        format.js  
      end
    end
  end

end