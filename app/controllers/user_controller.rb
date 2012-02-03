class UserController < ApplicationController
  before_filter :validate_institute_url
  before_filter :validate_logged_in_status
  def search_json
    #TODO security risk,exposes everyting to outside world
    #TODO use collections.where ???
    logger.info session[:user_name]
    @users = User.find(:all,:conditions =>['username like ? and institute_id = ?' , params[:username]+'%',get_institute_id])
    respond_to do |format|
      format.js  { render :json => @users.to_json }
    end
  end

  def profile
    @user = User.find(:first,:conditions => {:id => params[:user_id],:institute_id => get_institute_id})
  end

  def message_new
    @user = User.find(:first,:conditions => {:id => params[:user_id],:institute_id => get_institute_id})
    @message = Message.new
    @message.email =  true
    @message.sms =  false
    @message.twitter = false
    @message.facebook = false
  end

  def message_create
    @user = User.find(:first,:conditions => {:id => params[:user_id],:institute_id => get_institute_id})
    @message = Message.new(params[:message])
    @message.to_user = @user.id
    @message.from_user = session[:user_id]
    @message.unique_id = unique_id('message_').delete('-')

    respond_to do |format|
      if @message.save
        Delayed::Job.enqueue(MessageMailingJob.new(@message.id))
        format.html{redirect_to('/users/'+@user.id.to_s+'/profile')}
      else
        format.html{render :action => 'message_new'}
      end
    end


  end

  def message_done
    @user = User.find(:first,:conditions => {:id => params[:user_id],:institute_id => get_institute_id})
  end

  def resetpass
    @user = User.find(:first,:conditions => {:id => params[:user_id],:institute_id => get_institute_id})
    @helper_user_verify = HelperUserVerify.new
  end

  def resetpass_update
    #TODO use notices here
    @user = User.find(:first,:conditions => {:id => params[:user_id],:institute_id => get_institute_id})
    @helper_user_verify = HelperUserVerify.new(params[:helper_user_verify])
    success =  true
    if @helper_user_verify.pass != @helper_user_verify.pass_repeat
      success = false
      @helper_user_verify.errors.add('pass','passwords do not match')
    end

    if success
     success = @user.update_attribute(:password_crypt,md5_hash(@helper_user_verify.pass))
    end

    respond_to do |format|
      if success
        format.html{redirect_to('/users/'+@user.id.to_s+'/profile')}
      else
        format.html{render :action => 'resetpass'}
      end
    end
  end
  def edit_contact
    @user = User.find(:first,:conditions => {:id => params[:user_id],:institute_id => get_institute_id})
    @contact_detail = @user.contact_detail
    if @contact_detail.nil?
      @contact_detail = ContactDetail.new
      @contact_detail.user_id = @user.id
      @contact_detail.save
    end
    
  end

  def update_contact
    @user = User.find(:first,:conditions => {:id => params[:user_id],:institute_id => get_institute_id})
    @contact_detail = @user.contact_detail
    respond_to do |format|
      if @contact_detail.update_attributes(params[:contact_detail]) == true
        format.html{redirect_to('/users/'+@user.id.to_s+'/contact/edit', :notice => 'Contact details were successfully  updated.')}
      else
        formt.html {render :action => edit_contact}
      end
    end
    
    
  end

end
