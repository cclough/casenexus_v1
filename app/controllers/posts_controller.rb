class PostsController < ApplicationController
  before_filter :signed_in_user, only: [:index, :create, :update, :review, :approve]
  before_filter :correct_user, only: [:create, :update]
  before_filter :admin_user, only: [:review, :approve]

  # include all user session data e.g. notifications and username
  before_filter :session_data


  def index

    # get posts depending on :type sent from post pull-down menu

    # get only approved posts
    @posts_approved = Post.where('approved = true')

    # NB search and paginate methods are repeated for each IF outcome here, rather than unified
    # at the end, as felt like it would be less server intensive - may be wrong however
    if params[:type] == "local"

      # get posts from users within 10km

      #load in current user location
      @userlocation = [current_user.lat, current_user.lng]
      
      #geokit gem within function to get users within 100km
      #units and other options for this are set in the model
      @users_local = User.within(100, origin: @userlocation)

      # map id's of users within a distance, then get posts with this user_id...
      # (from Stack Overflow comment:
      # http://stackoverflow.com/questions/11975532/rails-get-posts-of-users-within-10km-of-a-point)
      # not elegant solution, could be better!

      @posts = @posts_approved.where(["user_id IN (?)", @users_local.map { |u| u.id }])
               .search(params[:search]).order('created_at desc')
               .paginate(per_page: 7, page: params[:page])

      # @posts = Post.where(user_id: User.within(10, origin: [51.123123, 0.1323123]))
      #          .search(params[:search]).order('created_at desc')
      #          .paginate(per_page: 7, page: params[:page])

      # @posts = @users_fifty.collect(&:posts).flatten
      #         .search(params[:search]).order('created_at desc')
      #         .paginate(per_page: 7, page: params[:page])

      # @posts = Post.joins(:user).merge(@users_fifty).search(params[:search]).order('created_at desc').paginate(per_page: 7, page: params[:page])

    elsif params[:type] == "glo"

      # default if not type param set - get posts from the entire world!
      @posts = @posts_approved.search(params[:search]).order('created_at desc')
              .paginate(per_page: 7, page: params[:page])

    elsif params[:type] == "rand" 

      # get randomly ordered posts....to let users explore
      @posts = @posts_approved.search(params[:search]).order("RANDOM()")
               .paginate(per_page: 7, page: params[:page])

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

  # update post
  def update
    
    #re-set approval
    @post.approved == :false

    if @post.update_attributes(params[:post])
      flash[:success] = '<strong>Success</strong> - Your post has been updated and is now awaiting approval'.html_safe
    else
      flash[:error] = '<strong>Error</strong> - Your post could not be updated at this time'.html_safe
    end

  end

  ############# REVIEW - APPROVE - DISAPPROVE ACTIONS ##############

  def review
    # unapproved post viewer
    # MAKE ADMIN ONLY
    @posts = Post.order("approved, created_at desc")
             .paginate(per_page: 7, page: params[:page])
  end

  def approve
    # approve post action
    # includes sending an email to the user
    @post = Post.find(params[:id])
    @post.toggle!(:approved)

    # if post has been approved, send good email, if disapproved, send bad email
    if @post.approved?

      #send approve email
      @user = User.find_by_id(@post.user_id)
      UserMailer.postapproved_email(@user).deliver

      # flash and re-direct
      @flash_text = "Success - Post for " + User.find_by_id(@post.user_id).name + " has been approved & an email sent"
      flash[:success] = @flash_text
      redirect_to '/review'

    else

      #send disapprove email
      @user = User.find_by_id(@post.user_id)
      UserMailer.postdisapproved_email(@user).deliver

      # flash and re-direct
      @flash_text = "Post for " + User.find_by_id(@post.user_id).name + " has been disapproved & an email sent"
      flash[:notice] = @flash_text
      redirect_to '/review'

    end
  end

  private

  # posts controller specific correct_user function from MH
  # why does it define 'post'?
  def correct_user
    @post = current_user.posts.find_by_id(params[:id])
    redirect_to root_path if @post.nil?
  end

end