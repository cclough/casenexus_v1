class UserMailer < ActionMailer::Base
  default :from => "info@casenexus.com"
  # is layout below actually used?
 	layout 'email' # use awesome.(html|text).erb as the layout

  def welcome_email(user)
    @user = user
    @url  = "http://example.com/login"
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "casenexus: Welcome")
  end

  def message_email(user_target, user_from, url)
    @user = user_target
    @url  = url
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "casenexus: you have been sent a message")
  end

  def feedback_new_email(user_target, user_from, url)
    @user_target = user_target
    @user_from = user_from
    @url  = url
    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(:to => email_with_name, :subject => "casenexus: new feedback")
  end

  def feedback_req_email(user_target, user_from, url)
    @user_target = user_target
    @user_from = user_from
    @url  = url
    email_with_name = "#{@user_target.name} <#{@user_target.email}>"
    mail(:to => email_with_name, :subject => "casenexus: request for feedback")
  end

  def postapproved_email(user)
    @user = user
    @url  = "http://example.com/login"
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "casenexus: post approved")
  end

  def postdisapproved_email(user)
    @user = user
    @url  = "http://example.com/login"
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "casenexus: post not approved")
  end

end
