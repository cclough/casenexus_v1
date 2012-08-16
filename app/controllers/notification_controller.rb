class NotificationController < ApplicationController

  before_filter :signed_in_user, only: [:map, :index, :edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  # include notifications instance var
  before_filter :session_data

  def index

    # build user messages, paginated, ordered
    #  get this to sort descending and paginate? 
  	@notifications = current_user.notifications.paginate(per_page: 10, page: 
              params[:page], order: "created_at DESC")
  end

  def sent
    # get sent messages
    @sentnotifications = Notification.paginate(per_page: 10, page: 
                params[:page], order: "created_at DESC").find_by_sender_id(current_user.id)
  end

  def show
    @notification = Notification.find(params[:id])

    # get sender name from sender_id field
    @notification_sender = User.find_by_id(@notification.sender_id)
  end

  def create

    @notification = Message.new(params[:message])

    # respond_to .js enables ajax create
    respond_to do |format|

      if @notification.save

        # get User object from id supplied
        user_target = User.find(@notification.user_id)
        # send message via email to target user
        UserMailer.message_email(user_target).deliver

        flash.now[:success] = 'Message sent!'
        format.js
      else
        # do I need the .html line below?
        format.html { render action: "new" }  
        format.js  
      end

    end
  end

end
