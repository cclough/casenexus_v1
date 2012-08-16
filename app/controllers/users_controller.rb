class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:map, :index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  
  # include all user session data e.g. messages and username
  before_filter :session_data

  def index

    # for new post
    # check if post already exists - if not don't build
    # if approved present, offer edit
    # if unapproved present, disable edit & new
    # NB view uses @post_can for decisions
    if current_user.posts.count == 0
      @post_can = "yes"
      @post = current_user.posts.build
    else
      if current_user.posts.first.approved?
        @post_can = "no"
        @post = current_user.posts.first
      else
        @post_can = "disable"
      end
    end

    # load json of map markers, inc. only user id, lat & lng
    respond_to do |format|
      format.html { render layout: 'map' }
      format.json { render json: User.all.map {|m|
                  { id: m.id, lat: m.lat, lng: m.lng } }}
    end

  end

  # user profile on map page
  def show

  	@user = User.find(params[:id])

    # load user's approved post
    @user_post = @user.posts.where('approved = true').first

    # for new message form
    @message = Message.new
    
    respond_to do |format|
      # don't load layout - make like a partial
      format.html { render :layout => false }
     end  
  end

  # load registration view  
  def new
    @user = User.new
  end

  # create user in model
  def create
    @user = User.new(params[:user])
  	if @user.save

      #send welcome email
      UserMailer.welcome_email(@user).deliver

      # sign in the new user
      sign_in @user
  		flash[:success] = "Welcome to casenexus.com"
  		redirect_to users_path
  	else
  		render 'new'
  	end
  end

  # load edit profile view
  def edit

    # remind that skype username is required to use the roulette
    if current_user.skype.blank?
      flash.now[:notice] = "<strong>Notice</strong> To use the roulette your must enter your skype username".html_safe
    end

    # check if profile is complete according to compeleted boolean 
    # (STILL NEED TO DECIDE ON BEST WAY TO DO THIS)
    if current_user.completed?
      flash.now[:notice] = "<strong>Notice</strong> Complete the rest of your profile".html_safe
    end

  end

  # change details in model
  def update
    if @user.update_attributes(params[:user])
      sign_in @user
      flash[:success] = '<strong>Success</strong> - Profile updated'.html_safe
      redirect_to users_path
    else
      render 'edit'
    end
  end

  private

  # Users controller specific user check functions (hartl)
  # check correct_user to make sure users can't access other's info
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user)
  end

end
