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
end
