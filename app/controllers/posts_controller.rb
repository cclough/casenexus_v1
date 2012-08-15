class PostsController < ApplicationController
  before_filter :signed_in_user, only: [:map, :index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  # include all user session data e.g. messages and username
  before_filter :session_data
  
  # for post sorting
  helper_method :sort_column, :sort_direction

  def index

    # get posts depending on :type sent from post pull-down menu
    if params[:type] == "ten"

      # get posts from users within 10km

      #load in current user location
      @userlocation = [current_user.lat, current_user.lng]
      #geokit gem within function to get users within 100km
      #units and other options for this are set in the model
      @users_ten = User.within(100, origin: @userlocation)
      # map id's of users within distance, then get posts with this user_id...
      # (from Stack Overflow comment - http://stackoverflow.com/questions/11975532/rails-get-posts-of-users-within-10km-of-a-point)
      # not elegant solution, could be better!
      @posts = Post.where(["user_id IN (?)", @users_ten.map { |u| u.id }])
               .search(params[:search]).order(sort_column + " " + sort_direction)
               .paginate(per_page: 7, page: params[:page])

    elsif params[:type] == "glo"

      # default if not type param set - get posts from the entire world!
      @posts = Post.search(params[:search]).order(sort_column + " " + 
               sort_direction).paginate(per_page: 7, page: params[:page])

    elsif params[:type] == "rand" 

      # get randomly ordered posts....to let users explore
      @posts = Post.search(params[:search]).order("RANDOM()").paginate(per_page: 7, page: params[:page])

    end

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
  # currently not in use ! pending removal
  private
  
  def sort_column
    Post.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def approve
    @posts = Post.where(approved: false)
  end

end