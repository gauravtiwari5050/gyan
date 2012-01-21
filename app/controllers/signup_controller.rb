#TODO error messages are not clear ,make the clearer
class SignupController < ApplicationController
  layout 'signup'
  def new
    @signup = Signup.new
  end
  def register_institute
    @signup = Signup.new(params[:signup])
    @institute = Institute.new
    @institute_url = InstituteUrl.new
    persist_success = true

    #transaction to persist information
    begin
      Signup.transaction do


        @institute.code = @signup.institute_url
        @institute.name = @signup.institute_name
     
        if !@institute.save
          logger.error "error saving institute information"
          raise "error saving institute information"
        end
        @institute_url.institute_id = @institute.id
        @institute_url.url = @institute.code + GyanV1::Application.config.url_suffix.to_s 

        if !@institute_url.save
          logger.error "error saving institute  url information"
          raise "error saving institute url information"
        end
        
        if @signup.admin_pass != @signup.admin_pass_confirm
          msg = "passwords do not match"
          @signup.errors.add('admin_pass',msg)
          raise msg
        end
        
        begin 
          #create admin user
          user =  User.new
          user.username = 'admin'
          user.email = @signup.admin_email
          user.password_crypt = md5_hash(@signup.admin_pass)
          user.institute_id = @institute.id
          user.user_type = 'ADMIN'
          user.is_validated = false
          user.one_time_login = unique_id('one_time_login')
          
          if !user.save
            msg = 'Error creating admin user!'
            logger.error msg
            raise msg
          end
       rescue
         @signup.errors.add('admin_pass','Error creating admin user ,probabaly the email is already being used') 
         raise 'Error creating admin user'
       end



      end
    rescue Exception => e
      logger.error "Something went wrong"
      persist_success = false
      @signup.errors.add("institute_url",e.to_s)
    end
    if persist_success
      respond_to do|format|
        format.html {redirect_to('http://'+@institute_url.url.to_s+'/login')}
      end
    else
      respond_to do|format|
        format.html {render :action => "new"}
      end
      
    end

  end




end
