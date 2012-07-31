class MessagesController < ApplicationController

  before_filter :signed_in_user, only: [:map, :index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  # include notifications instance var
  before_filter :show_messages


	def index

    #  get this to sort descending and paginate? 
		@messages = current_user.messages.all
    # .order('created_at desc').paginate(:per_page => 10, :page => params[:page])


	end

  def create

    @message = Message.new(params[:message])
    # encode current user_id
    # @case.marker_id = current_user.user_id

    if @message.save

      # get User object from id supplied
      user_target = User.find(@message.user_id)

      # send message via email to target user
      UserMailer.message_email(user_target).deliver

      flash[:success] = "Message sent!"
      redirect_to users_path
    else
      render 'new'
    end
  end

end
