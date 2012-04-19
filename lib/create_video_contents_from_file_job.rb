class CreateVideoContentsFromFileJob < Struct.new(:file_url,:task_id)
  def perform
    success =  true
    Delayed::Worker.logger.info 'Creating video content from  : ' + file_url 
    begin
    file = File.new(file_url,"r")
    while (line = file.gets)
      Delayed::Worker.logger.info line
      contents = line.split(",")
      video = ContentVideo.new
      video.branch = contents[0]
      video.course = contents[1]
      video.topic = contents[2]
      video.url = contents[3]
      video.credits = contents[4]
      video.save
    end
    file.close

    rescue Exception => e
      success = false 
      Delayed::Worker.logger.info e.message
      Delayed::Worker.logger.info e.backtrace.inspect
    end
    task_obj = Task.find(task_id)

    if success == false
      task_obj.update_attributes(:completion_status => 'COMPLETE',:execution_status => 'FAILED',:output => 'Invalid File format/structure.Please make sure the file has correct structure') 
    else
      task_obj.update_attributes(:completion_status => 'COMPLETE',:execution_status => 'SUCCESS',:output => "Video Content Uploaded") 
    end
    Delayed::Job.enqueue(ObjectDestroyJob.new(task_obj.class.to_s,task_obj.id),:run_at => 30.seconds.from_now)
    
  end
end
