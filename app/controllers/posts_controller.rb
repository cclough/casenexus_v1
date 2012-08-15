class PostsController < ApplicationController
  before_filter :signed_in_user, only: [:map, :index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  # include all user session data e.g. messages and username
  before_filter :session_data
  
  # for post sorting
  helper_method :sort_column, :sort_direction

  def index
    # get all posts, paginated, ordered, and matching any search params
    @posts = Post.search(params[:search]).order(sort_column + " " + 
             sort_direction).paginate(per_page: 7, page: params[:page])
  end

  def create

    # new post var for post form
    @post = current_user.posts.build(params[:post])

    # respond_to .js enables ajax create
    respond_to do |format|
      if @post.save
        flash.now[:success] = 'your post has been sent for approval!'
        format.js
      else
        # do I need the .html line below?
        format.html { render action: "new" }  
        format.js  
      end
    end

  end

  # post sort column model calls
  private
  
  def sort_column
    Post.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end