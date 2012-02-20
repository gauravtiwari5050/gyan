class UserMailer < ActionMailer::Base
  default :from => "gauravt@cloudclasshq.com"
  def registration_confirmation(user)
    @user = user
    @url = @user.institute.institute_url.url
    @url = 'http://'+@url+'/register/verify/'+@user.one_time_login.to_s
    @login_url = 'http://'+@user.institute.institute_url.url+"/login"
    @institute_name = @user.institute.name
    @user_type = @user.user_type.downcase
    mail(:to => user.email, :subject => "New user Registration , " + @institute_name + " ,CloudClass")
  end

  def message_send(message)
    @message = message
    @to_user = User.find(@message.to_user)
    @from_user = User.find(@message.from_user)
    @institute_name = @from_user.institute.name
    @login_url = 'http://'+@from_user.institute.institute_url.url+"/login"
    mail(:to => @to_user.email, :subject => @message.subject)
  end
    
end
