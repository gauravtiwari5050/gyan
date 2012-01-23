class RegistrationController < ApplicationController
  def teacher_new
    @helper_registration = HelperRegistration.new
  end
  def student_new
    @helper_registration = HelperRegistration.new
  end
  def forgotpass_new
    @helper_registration = HelperRegistration.new
  end

  def forgotpass_create
    @helper_registration = HelperRegistration.new(params[:helper_registration])
    success = verify_recaptcha(@helper_registration)
    if success == true
      user = User.find_by_email(@helper_registration.email)
      if user.nil?
        success =  false
        @helper_registration.errors.add('email','no such user exists')
      else
         if !user.update_attribute(:one_time_login,unique_id(''))
          success =  false
          @helper_registration.errors.add('email','error updating attributes')
         else
            Delayed::Job.enqueue(MailingJob.new(user.id))
         end
      end
    end
      
      if success == true
        respond_to do |format|
          format.html {redirect_to('/register/success')}
        end
      else
        respond_to do |format|
          format.html {render :action => 'teacher_new'}
        end
      end
    
  end
  def teacher_create
    @helper_registration = HelperRegistration.new(params[:helper_registration])
    success = verify_recaptcha(@helper_registration)
    if success == true
      user = create_vanilla_user(@helper_registration.email,'TEACHER')
      begin
        success = user.save
      rescue Exception => e
        @helper_registration.errors.add('email',e.message)
        success = false
      end
    end

      if success == true
        respond_to do |format|
          format.html {redirect_to('/register/success')}
        end
      else
        respond_to do |format|
          format.html {render :action => 'teacher_new'}
        end
      end
  end
  def student_create
    @helper_registration = HelperRegistration.new(params[:helper_registration])
    success = verify_recaptcha(@helper_registration)
    if success == true
      user = create_vanilla_user(@helper_registration.email,'STUDENT')
      begin
        success = user.save
      rescue Exception => e
        @helper_registration.errors.add('email',e.message)
        success = false
      end
    end

      if success == true
        respond_to do |format|
          format.html {redirect_to('/register/success')}
        end
      else
        respond_to do |format|
          format.html {render :action => 'stdudent_new'}
        end
      end
  end

  def success
    @message = "Regsitration successful,an email has been sent to the id provided.Please use that for next steps"
    
  end

  def verify
    one_time_id = params[:one_time_id]
    @user = User.find_by_one_time_login(one_time_id)
    @helper_user_verify = HelperUserVerify.new
  end

  def verify_update
    one_time_id = params[:one_time_id]
    @user = User.find_by_one_time_login(one_time_id)
    @helper_user_verify = HelperUserVerify.new(params[:helper_user_verify])
    persist_success = true
    if @helper_user_verify.pass != @helper_user_verify.pass_repeat
      @helper_user_verify.errors.add('pass','Passwords do not match')
      persist_success = false
    end
    if persist_success
      @user.username = @helper_user_verify.username
      @user.password_crypt = md5_hash(@helper_user_verify.pass)
      @user.one_time_login = nil
      @user.is_validated = true
      begin
        HelperUserVerify.transaction do
          @user.save
        end
      rescue Exception => e
        @helper_user_verify.errors.add('username',e.message)
        persist_success = false
      end
    end
      
    if persist_success == true
      respond_to do |format|
        format.html {redirect_to('/register/success')}
      end
    else
      respond_to do |format|
        format.html {render :action => 'verify'}
      end
    end

  end
end
