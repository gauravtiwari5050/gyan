module Util
  def create_vanilla_user(email,user_type,institute_id)
    user = User.new
    user.institute_id = institute_id
    user.email = email
    user.user_type = user_type
    user.one_time_login = unique_id('')
    user.is_validated = false
    return user
  end
  
  def unique_id(prefix)
  require 'uuidtools'
    return  prefix.to_s + UUIDTools::UUID.timestamp_create.to_s
  end

  def create_new_task(type,description,user_id,save)
    
    task = Task.new
    task.task_type = type
    task.description = description
    task.completion_status = 'RUNNING'
    task.execution_status = 'PENDING'
    task.output = ''
    task.user_id = user_id
    if save == true
      task.save
    end
    return task
  end

  def create_new_message(subject,content,from_user_id,to_user_id,email,sms,facebook,twitter,save)
    message = Message.new
    message.unique_id = unique_id('message_')
    message.subject = subject
    message.content = content
    message.from_user = from_user_id
    message.to_user = to_user_id
    message.email = email
    message.sms = sms
    message.facebook = facebook
    message.twitter = twitter
    if save == true
      message.save
    end
    return message
  end
  def add_users_from_file(user_type,helper_file)
    if helper_file.nil?
      return false,'No file added'
    end
    @helper_file = HelperFile.new(helper_file)
    file_url = 'public' + @helper_file.file.url.to_s;
    logger.info  file_url
    task = Task.new
    task.task_type = 'CREATE_USER_FROM_FILE'
    task.description = 'creates users from uploaded file'
    task.completion_status = 'RUNNING'
    task.execution_status = 'PENDING'
    task.output = ''
    task.user_id = current_user.id
    task.save

    Delayed::Job.enqueue(CreateUserFromFileJob.new(file_url,task.id,user_type,get_institute_id))
  end
  def add_users_from_list(user_type,user_list)
   if user_list.nil? || user_list.length == 0
    return false,'the list of email you provided is not valid'
   end
   user_emails = user_list.split(/[\n ,]+/)
   for email in user_emails
    email = email.strip! || email
    user = create_vanilla_user(email,user_type)
    begin
      
      if !user.save
        logger.error 'ERROR SAVING USER' + user.inspect
        raise 'Error creating user from the list provided'
      end
      Delayed::Job.enqueue(MailingJob.new(user.id))
    rescue Exception => e
      logger.info e.message
    end
   end

   return true,'The list of users has been queued for processing.Emails will be sent out to the users soon'
    
  end

end
