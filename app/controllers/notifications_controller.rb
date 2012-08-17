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

    # find incoming notification type
    @ntype = params[:notification][:ntype]

    # load new notification
    @notification = Notification.new(params[:notification])

    # respond_to .js enables ajax create
    respond_to do |format|

      if @notification.save

        # get User object from id supplied
        user_target = User.find(@notification.user_id)
        
        # EMAIL NOTIFICATION TOO
        # Doing this emailing (requiring an if statement) here to keep it out of other controllers
        # MESSAGE email
        if @ntype == "message"
          UserMailer.message_email(user_target, user_from, url).deliver
        # FEEDBACK NEW email
        elsif @ntype == "feedback_new"
          UserMailer.feedback_new_email(user_target, user_from, url).deliver
        # FEEDBACK REQUEST email
        elsif @ntype == "feedback_req"
          UserMailer.feedback_req_email(user_target, user_from, url).deliver
        end

        # might not need this flash
        flash.now[:success] = 'Notification sent & emailed!'
        format.js

      else
        # do I need the .html line below?
        format.html { render action: "new" }  
        format.js  
      
      end

    end


  end

end
