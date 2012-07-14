class UserMailer < ActionMailer::Base
  default :from => "info@casenexus.com"
 	layout 'email' # use awesome.(html|text).erb as the layout

  def welcome_email(user)
    @user = user
    @url  = "http://example.com/login"
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "Welcome to casenexus.com")
  end

  def message_email(user)
    @user = user
    @url  = "http://example.com/login"
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "You have been sent a message on casenexus.com")
  end
end
