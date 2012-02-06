include Util
class BulkMessagingJob
  def initialize(task,users,from_user,subject,content,is_email,is_sms,is_fb,is_twitter)
    @task = task
    @users = users
    @from_user = from_user
    @subject = subject
    @content = content
    @is_email = is_email
    @is_sms = is_sms
    @is_fb = is_fb
    @is_twitter = is_twitter
  end

  def perform
  #TODO validation here ,null checks ?
  success =  true
  begin
    for user in @users
      message = create_new_message(@subject,@content,@from_user.id ,user.id,@is_email,@is_sms,@is_fb,@is_twitter,true)
      Delayed::Job.enqueue(MessageMailingJob.new(message.id)) 
    end
  rescue Exception =>e
    success = false
    Delayed::Worker.logger.info e.message
    Delayed::Worker.logger.info e.backtrace.inspect
  end
  if success == false
      @task.update_attributes(:completion_status => 'COMPLETE',:execution_status => 'FAILED',:output => 'Something went wrong.We are looking into it') 
  else
      @task.update_attributes(:completion_status => 'COMPLETE',:execution_status => 'SUCCESS',:output => "Messages are being sent,and would be finished in couple of minutes") 
    
  end
    Delayed::Job.enqueue(ObjectDestroyJob.new(@task.class.to_s,@task.id),:run_at => 30.seconds.from_now)
    
  end
end
