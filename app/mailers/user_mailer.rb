class UserMailer < ActionMailer::Base
  default :from => "gauravt@cloudclasshq.com"
  def registration_confirmation(user)
    @user = user
    @url = @user.institute.institute_url.url
    @url = 'http://'+@url+'/register/verify/'+@user.one_time_login.to_s
    mail(:to => user.email, :subject => "Registered")
  end

  def message_send(message)
    @message = message
    @to_user = User.find(@message.to_user)
    @from_user = User.find(@message.from_user)
    mail(:to => @to_user.email, :subject => @message.subject)
  end
    
end
