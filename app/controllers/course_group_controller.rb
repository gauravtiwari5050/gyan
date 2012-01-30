class CourseGroupController < ApplicationController
  impressionist
  def home
    @group = CourseGroup.find(params[:id])
  end

  def people
    @group = CourseGroup.find(params[:id])
    @users = @group.users
  end

  def pads
    @group = CourseGroup.find(params[:id])
  end

  def pads_new
    @group = CourseGroup.find(params[:id])
    etherpad = Etherpad.new
    etherpad.course_group_id = @group.id
    etherpad.status = 'CREATING'
    etherpad.server = '178.79.183.87:9001'
    etherpad.name = unique_id('').delete('-')
    #TODO what if the save fails
    etherpad.save

    Delayed::Job.enqueue(CollaborationJob.new(etherpad.id))
    respond_to do |format|
      format.html{redirect_to('/groups/'+@group.id.to_s+'/collaborate')}
    end
    
  end

end
