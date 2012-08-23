class PostsController < ApplicationController
  before_filter :signed_in_user
  before_filter :admin_user, only: [:review, :approve]

  # include all user session data e.g. notifications and username
  before_filter :session_data


  def index


    # get only approved posts
    @posts_approved = Post.where('approved = true')

    ### get posts depending on :type sent from post pull-down menu
    # NB search and paginate methods are repeated for each IF outcome here, rather than unified
    # at the end, as felt like it would be less server intensive - may be wrong however
    if params[:type] == "local"

      # get posts from users within 10km

      #load in current user location
      @userlocation = [current_user.lat, current_user.lng]
      
      #geokit gem within function to get users within 100km
      #units and other options for this are set in the model
      @users_local = User.within(100, origin: @userlocation)

      # cool code from http://stackoverflow.com/questions/11975532/rails-get-posts-of-users-within-10km-of-a-point
      # depends on acts_as_mappable in Post model
      # 100 refers to 100km - this must also be set in the users#index view
      @posts = @posts_approved.joins(:user).within(100, origin: @userlocation)
               .search(params[:search]).order('created_at desc')
               .paginate(per_page: 7, page: params[:page])

      # back-up solution if code above doesn't work (not as efficient)
      # @posts = @posts_approved.where(["user_id IN (?)", @users_local.map { |u| u.id }])
      #          .search(params[:search]).order('created_at desc')
      #          .paginate(per_page: 7, page: params[:page])

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
        flash.now[:success] = '<strong>Success</strong> - Your post has been sent for approval!'.html_safe
        format.js
      else
        # recently got rid of .html here, does it still work? and does flash work?
        flash.now[:error] = '<strong>Error</strong> - Your post could not be saved, please try again!'.html_safe
        format.js  
      end
    end
  end

  # update post
  def update
    
    if @post.update_attributes(params[:post])

      #re-set approval
      @post.approved == :false

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

end