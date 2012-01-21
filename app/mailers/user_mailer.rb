class UserMailer < ActionMailer::Base
  default :from => "gtcchq@gmail.com"
  def registration_confirmation(user)
    @user = user
    @url = @user.institute.institute_url.url
    @url = 'http://'+@url+'/register/verify/'+@user.one_time_login.to_s
    mail(:to => user.email, :subject => "Registered")
  end
end
