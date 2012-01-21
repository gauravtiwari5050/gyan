class AdminController < ApplicationController
  before_filter :validate_institute_url
  before_filter {|role| role.validate_role 'ADMIN'}
  def home
    
  end

  def department_index
    @departments = Department.find(:all,:conditions => {:institute_id => get_institute_id})
  end

  ##functions to add teachers,students
  def teachers_new
  end
  def students_new
  end

  def teachers_add
   user_list = params[:user_list]
   user_list = user_list 
   user_emails = user_list.split(/[\n ,]+/)
   for email in user_emails
    email = email.strip! || email
    user = create_vanilla_user(email,'TEACHER')
    begin
      user.save
      Delayed::Job.enqueue(MailingJob.new(user.id))
    rescue Exception => e
      logger.info e.message
    end
   end
  respond_to do |format|
    format.html {redirect_to('/admin')}
  end
  end

  def students_add
   user_list = params[:user_list]
   user_list = user_list 
   user_emails = user_list.split(/[\n ,]+/)
   for email in user_emails
    email = email.strip! || email
    user = create_vanilla_user(email,'STUDENT')
    begin
      user.save
      Delayed::Job.enqueue(MailingJob.new(user.id))
    rescue Exception => e
      logger.info e.message
    end
   end
  respond_to do |format|
    format.html {redirect_to('/admin')}
  end
  end

end
