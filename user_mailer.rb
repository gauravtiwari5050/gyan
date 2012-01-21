class UserMailer < ActionMailer::Base
  default :from => "gtcchq@gmail.com"
  def registration_confirmation(user)
    mail(:to => user.email, :subject => "Welcome to CloudClass" )
  end
end
