class CourseController < ApplicationController
  layout :choose_layout
  before_filter :validate_institute_url
  before_filter {|role| role.validate_course_access params[:id]}

  def choose_layout
   if action_name == 'file_index'
    return 'course-fileviewer'
   elsif action_name.start_with?'channel'
    return 'channel'
   else
    return 'course'
   end     
  end


  def show
    @course = Course.find(params[:id])
  end

  def announcement_new
    @course = Course.find(params[:id])
    @course_announcement = CourseAnnouncement.new
  end
  
  def announcement_create
    @course = Course.find(params[:id])
    @course_announcement = CourseAnnouncement.new(params[:course_announcement])
    @course_announcement.course_id = @course.id
    respond_to do |format|
      if @course_announcement.save
        format.html { redirect_to('/courses/' + @course.id.to_s + '/announcements', :notice => 'Course file was successfully created.') }
      else
        format.html { render :action => "announcement_new" }
      end
    end
  end
  
  def announcement_index
    @course = Course.find(params[:id])
  end
  
  def assignment_new
    @assignment = Assignment.new
    @course = Course.find(params[:id])

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def assignment_create
    @assignment = Assignment.new(params[:assignment])
    @course = Course.find(params[:id])
    @assignment.course_id = @course.id
    #id,key =  upload_to_scribd(@assignment.assignment_file)
    #@assignment.scribd_id = id.to_s
    #@assignment.scribd_key = key.to_s


    respond_to do |format|
      if @assignment.save
        Delayed::Job.enqueue(ScribdUploader.new(@assignment,@assignment.assignment_file))
        format.html { redirect_to('/courses/' + @course.id.to_s + '/assignments', :notice => 'Course file was successfully created.') }
      else
        @assignment.errors.add('detail','Error in uploading your assignment kindly try again')
        format.html { render :action => "assignment_new" }
      end
    end
  end
  
  def assignment_index
    @course = Course.find(params[:id])
  end
  
  def assignment_show
    @course = Course.find(params[:id])
    @assignment = Assignment.find(params[:ass_id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @assignment }
    end
  end


  def file_new
    @course_file = CourseFile.new
    @course = Course.find(params[:id])


    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @course }
    end
  end

  def file_create
    @course = Course.find(params[:id])
    @course_file = CourseFile.new(params[:course_file])
    @course_file.course_id = @course.id
    #id,key =  upload_to_scribd(@course_file.content)
    #@course_file.scribd_id = id.to_s
    #@course_file.scribd_key = key.to_s
    respond_to do |format|
      if @course_file.save
        Delayed::Job.enqueue(ScribdUploader.new(@course_file,@course_file.content))
        format.html { redirect_to('/courses/' + @course.id.to_s + '/files', :notice => 'Course file was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
   
  end

  def file_index
    @course = Course.find(params[:id])
  end

  ##for assigning teacher to a course
  def teacher_assign
    @course_allocation = CourseAllocation.find_by_course_id(params[:id])
    @course = Course.find(params[:id])
    @teachers = get_teachers_for_institute
  end

  def teacher_assign_create
    @course_allocation_new = CourseAllocation.new(params[:course_allocation])
    @course_allocation = CourseAllocation.find_by_course_id(params[:id])
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course_allocation.update_attribute(:user_id,@course_allocation_new.user_id)
        format.html {redirect_to ('/courses/'+@course.id.to_s+'/home')}
      else
        format.html {render :action => "teacher_assign"} 
      end
    end
    
  end

  ##assignment solution
  def assignment_solution_new
    @course = Course.find(params[:id])
    @assignment = Assignment.find(params[:ass_id])
    #@assignment_solution = AssignmentSolution.find(:first,:limit => 1 ,:conditions => {:assignment_id => @assignment.id,:user_id => session[:user_id]})
    #if @assignment_solution.nil?
    #logger.info 'no solution found creating new one'
    @assignment_solution = AssignmentSolution.new
    #end

  end

  def assignment_solution_create
    @course = Course.find(params[:id])
    @assignment = Assignment.find(params[:ass_id])
    @assignment_solution = AssignmentSolution.new(params[:assignment_solution])
    @assignment_solution.assignment_id = @assignment.id
    @assignment_solution.user_id = session[:user_id]
    id,key =  upload_to_scribd(@assignment_solution.file)
    @assignment_solution.scribd_id = id.to_s
    @assignment_solution.scribd_key = key.to_s
    @current_assignment_solution = AssignmentSolution.find(:first,:limit => 1 ,:conditions => {:assignment_id => @assignment.id,:user_id => session[:user_id]})
    ##bad bad way what a waste TODO
    if !@current_assignment_solution.nil?
      @current_assignment_solution.destroy
    end
    respond_to do |format|
      if @assignment_solution.save
       format.html {redirect_to('/courses/'+@course.id.to_s+'/assignments/'+@assignment.id.to_s+'/solutions/'+@assignment_solution.id.to_s)}
      else
       format.html {render :action => "assignment_solution_new"}
      end
    end
      
    
  end

  def evaluate_home
    @course = Course.find(params[:id])
    @assignment = Assignment.find(params[:ass_id])
  end

  def assignment_solution_evaluate
    @course = Course.find(params[:id])
    @assignment = Assignment.find(params[:ass_id])
    @assignment_solution = AssignmentSolution.find(params[:sol_id])
  end

  def channel_show
    @course = Course.find(params[:id])
  end
  def channel_new
    @course = Course.find(params[:id])
    bbb = Bbb.new
    bbb.course_id = @course.id
    bbb.name = @course.name.delete(' ') ##what if @course name is nill ? TODO
    bbb.meeting_id = unique_id('').delete('-') 
    bbb.attendee_pw = unique_id('').delete('-') 
    bbb.moderator_pw = unique_id('').delete('-') 
    bbb.status = 'CREATING'
    bbb.save ##TODO what if this fails
    Delayed::Job.enqueue(ChannelCreator.new(bbb.id))
    respond_to do |format|
     format.html{redirect_to('/courses/'+@course.id.to_s+'/channel')}  
    end

  end

end
