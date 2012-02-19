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
          @success_message = 'An email has been sent to your email id.Please follow the instructions to reset the password.'
          flash[:notice] = @success_message
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
          @success_message = 'An email has been sent to your email id.Please follow the instructions to complete registration.'
          flash[:notice] = @success_message
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
          @success_message = 'An email has been sent to your email id.Please follow the instructions to complete registration.'
          flash[:notice] = @success_message
          format.html {redirect_to('/register/success')}
        end
      else
        respond_to do |format|
          format.html {render :action => 'stdudent_new'}
        end
      end
  end

  def success
    
  end

  def verify
    one_time_id = params[:one_time_id]
    @user = User.find_by_one_time_login(one_time_id)
    @helper_user_verify = HelperUserVerify.new
  end

  def verify_update
    one_time_id = params[:one_time_id]
    verification_message = "Verification successful"
    @user = User.find_by_one_time_login(one_time_id)
    @helper_user_verify = HelperUserVerify.new(params[:helper_user_verify])
    persist_success = true
    if @helper_user_verify.pass != @helper_user_verify.pass_repeat
      @helper_user_verify.errors.add('pass','Passwords do not match')
      persist_success = false
      verification_message = "Passwords do not match"
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
        verification_message = e.message
      end
    end
      
    if persist_success == true
      respond_to do |format|
        @success_message = 'Your account has been validated. <a href="/login"> Please login here </a>'
        flash[:notice] = @success_message
        format.html {redirect_to('/register/success')}
      end
    else
      respond_to do |format|
        flash[:alert] =  verification_message
        format.html {redirect_to('/register/verify/'+one_time_id)}
      end
    end

  end
end
