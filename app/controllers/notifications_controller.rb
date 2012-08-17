class NotificationsController < ApplicationController
  before_filter :signed_in_user

  # include all user session data e.g. notifications and username
  before_filter :session_data

  def index

    # build user notifications, paginated, ordered
    #  get this to sort descending and paginate? 
  	@notifications = current_user.notifications.paginate(per_page: 10, page: 
              params[:page], order: "created_at DESC")
  end

  def sent
    # get sent notifications
    @notifications_sent = Notification.paginate(per_page: 10, page: 
                          params[:page], order: "created_at DESC")
                          .find_by_sender_id(current_user.id)
  end

  def show
    @notification = Notification.find(params[:id])

    # get sender name from sender_id field
    @notification_sender = User.find_by_id(@notification.sender_id)
  end

  def create

    @notification = Notification.new(params[:notification])

    # respond_to .js enables ajax create
    respond_to do |format|

      if @notification.save

        # get User object from id supplied
        user_target = User.find(@notification.user_id)
        # send notification via email to target user
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
