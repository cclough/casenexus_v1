class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:map, :index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  def index
    @post = current_user.posts.build
    @posts = Post.all

    # @notify = ""
    # @usersonline = SessionTracker.new("user", $redis).active_users
  
    @markers = User.all
    respond_to do |format|
      format.html
      format.json { render json: @markers } #need to make this so only lat and lng are included!
    end

  end

  def roulette
  end

  def list
    @users = User.paginate(page: params[:page])
  end

  def show
  	@user = User.find(params[:id])
    @message = Message.new
    
    respond_to do |format|
      format.html { render :layout => false }
     end  
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
  	if @user.save
      UserMailer.welcome_email(@user).deliver
      sign_in @user
  		flash[:success] = "Welcome to casenexus!"
  		redirect_to users_path
  	else
  		render 'new'
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      sign_in @user
      flash[:success] = "Profile updated"
      redirect_to users_path
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_path
  end

  private

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in." unless signed_in?
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user)
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end
end
