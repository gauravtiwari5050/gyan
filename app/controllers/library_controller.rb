class LibraryController < ApplicationController
  def upload_video
    @helper_file = HelperFile.new
  end

  def upload_video_task
    @helper_file = HelperFile.new(params[:helper_file])
    file_url = 'public' + @helper_file.file.url.to_s;
    logger.info  file_url
    task = Task.new
    task.task_type = 'CREATE_VIDEO_CONTENTS_FROM_FILE'
    task.description = 'adding content to video library using a text file'
    task.completion_status = 'RUNNING'
    task.execution_status = 'PENDING'
    task.output = ''
    task.user_id = current_user.id
    task.save
    Delayed::Job.enqueue(CreateVideoContentsFromFileJob.new(file_url,task.id))
    
    respond_to do |format|
      format.html { redirect_to('/library/upload_video_contents') }
    end
    
  end

  def home
  end
end
