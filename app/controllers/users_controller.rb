class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:map, :index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  # include notifications instance var
  before_filter :show_messages

  # helper method for post sorting
  helper_method :sort_column, :sort_direction

  def index

    #vars for post list and new post
    @post = current_user.posts.build
    # @posts = Post.all
 

    @posts = Post.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])

   
    # populate post filter drop downs
    @countries = User.find(:all, :order => 'country').uniq{|x| x.country}
    @cities = User.find(:all, :order => 'city').uniq{|x| x.city}
    @skills = User.find(:all, :order => 'skill').uniq{|x| x.skill}

    #map marker array
    @markers = User.all

    respond_to do |format|
      format.html
      format.json { render json: @markers } #need to make this so only lat and lng are included!
    end

  end

  def roulette
  end

  def show
  	@user = User.find(params[:id])
    @message = Message.new
    
    respond_to do |format|
      # don't load layout - make like a partial
      format.html { render :layout => false }
     end  
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
  	if @user.save

      #send welcome email
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

  def extend
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

  # post sorting param grabbers
  def sort_column
    Post.column_names.include?(params[:sort]) ? params[:sort] : "user_id"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
