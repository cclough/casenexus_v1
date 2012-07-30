class PostsController < ApplicationController
  before_filter :signed_in_user, only: [:map, :index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  # include notifications instance var
  before_filter :show_messages
  
  # helper method for post sorting
  helper_method :sort_column, :sort_direction

  def index
    # posts = Post.all

    @posts = Post.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 20, :page => params[:page])

    # respond_to do |format|
    #   format.html { render :layout => false }
    # end  
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

  private
  
  def sort_column
    Post.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end