class UserMailer < ActionMailer::Base
  default :from => "register@remindmetolive.com"

  def registration_confirmation(user)
    @user = user
    mail = mail(:to => "<#{user.email}>", :subject => "Registered")
    mail
  end

  def reset_password(user)
    @user = user
    mail = mail(:to => "<#{user.email}>", :subject => "Reset Password")
    mail
  end
end
