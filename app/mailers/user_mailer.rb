class UserMailer < BaseMailer

  def welcome_email(user)
    @user = user
    @url  = "http://apibootstraper.com/login"
    mail(:to => user.email, :subject => "Welcome to example.com")
  end

end
