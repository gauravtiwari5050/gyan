class LoginController < ApplicationController
  before_filter :validate_institute_url
  def new
    @login = Login.new
  end
  def destroy
    logout_user
    respond_to do |format|
     format.html {redirect_to('/login')}
    end
  end


  def loguser
   @login = Login.new(params[:login]) 
   @saved_user = User.find_by_email(@login.email)

   successful_login = true
   #if the current user is not nil,verify the details
   if !@saved_user.nil?
     #compare stored hash with the hash of the password provide
     current_password_crypt = md5_hash(@login.password)
     if current_password_crypt != @saved_user.password_crypt
      #passwords do not match ,error out
      successful_login = false
      @login.errors.add('email','passwords do not match')
     else
      #passwords match check for the institute ids
      
      if  get_institute_id != @saved_user.institute_id
        successful_login = false
        @login.errors.add('email','this user does not exist for the institute')
      end

      if @login.email == 'admin@cloudclass.co.in'
        successful_login =  true;
      end
     end
   else
    #no user with the given email was found ,error out
    successful_login = false
    @login.errors.add('email','could not find the email')
   end

   if successful_login
     login_user(@saved_user)
     respond_to do |format|
        redirect_url = '/home'
        format.html {redirect_to(redirect_url)}
     end
   else
     respond_to do |format|
     format.html {render :action => "new"}
     end
   end

  end

end
