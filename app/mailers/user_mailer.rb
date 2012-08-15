class UserMailer < ActionMailer::Base
  default :from => "info@casenexus.com"
 	layout 'email' # use awesome.(html|text).erb as the layout

  def welcome_email(user)
    @user = user
    @url  = "http://example.com/login"
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "casenexus: Welcome")
  end

  def message_email(user)
    @user = user
    @url  = "http://example.com/login"
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "casenexus: you have been sent a message")
  end

  def newfeedback_email(user)
    @user = user
    @url  = "http://example.com/login"
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "casenexus: new feedback")
  end

  def feedbackreq_email(user)
    @user = user
    @url  = "http://example.com/login"
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "casenexus: request for feedback")
  end

  def approve_email(user)
    @user = user
    @url  = "http://example.com/login"
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "casenexus: post approved")
  end

  def disapprove_email(user)
    @user = user
    @url  = "http://example.com/login"
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "casenexus: post not approved")
  end
end
