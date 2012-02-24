class CourseGroupController < ApplicationController
  impressionist
  before_filter :validate_institute_url,:validate_logged_in_status
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
    etherpad.server = 'ec2-50-19-46-255.compute-1.amazonaws.com:9001'
    etherpad.name = unique_id('').delete('-')
    #TODO what if the save fails
    etherpad.save

    Delayed::Job.enqueue(CollaborationJob.new(etherpad.id))
    respond_to do |format|
      format.html{redirect_to('/groups/'+@group.id.to_s+'/collaborate')}
    end
    
  end

  def delete
    @group = CourseGroup.find(params[:id])
    course = @group.course
    @group.destroy

    respond_to do |format|
      format.html {redirect_to('/courses/'+course.id.to_s+'/groups')}
    end
  end

end
