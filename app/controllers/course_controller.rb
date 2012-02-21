class CourseController < ApplicationController
  impressionist
  layout :choose_layout
  before_filter :validate_institute_url
  before_filter {|role| role.validate_course_access params[:id]}
  before_filter :teacher_admin_access ,:only => [:announcement_new,:announcement_create,:assignment_new,:assignment_create,:group_assign,:group_assign_manual_new,:group_assign_manual_create,:teacher_assign,:teacher_assign_create,:forum_new,:channel_new]

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
        format.js { render :json => @course_announcement }
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
    @assignment.build_appfile

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def assignment_create
    logger.info 'HYD -> ' + params.inspect
    @assignment = Assignment.new(params[:assignment])
    @course = Course.find(params[:id])
    @assignment.course_id = @course.id
    appfile = Appfile.new(params[:assignment][:appfile_attributes])
    #logger.info 'HYD -> ' + (appfile.content||" ").to_s 
    success = true
    begin
     Assignment.transaction do
      success = @assignment.save
      #if success == true 
      #  appfile.appfileable_id = @assignment.id
      #  appfile.appfileable_type = @assignment.class.to_s
      #  success = appfile.save
      #end
      if success == false
        raise 'Error creating assignment'
      end
     end
    rescue Exception => e
      logger.error 'Error creating assignment' + e.message
      @assignment.errors.add('detail',e.message)
      success = false
    end


    respond_to do |format|
      if success
        if !@assignment.appfile.nil?
          Delayed::Job.enqueue(AppfileUploader.new(@assignment.appfile.id))
        end
        format.html { redirect_to('/courses/' + @course.id.to_s + '/assignments', :notice => 'Course file was successfully created.') }
      else
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
    @appfile = Appfile.new
    @course = Course.find(params[:id])


    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @course }
    end
  end

  def file_create
    @course = Course.find(params[:id])
    @appfile = Appfile.new(params[:appfile])
    @appfile.appfileable_id = @course.id
    @appfile.appfileable_type = @course.class.to_s
    respond_to do |format|
      if @appfile.save
        Delayed::Job.enqueue(AppfileUploader.new(@appfile.id))
        format.html { redirect_to('/courses/' + @course.id.to_s + '/files', :notice => 'Course file was successfully created.') }
      else
        format.html { render :action => "file_new" }
      end
    end
   
  end

  def file_index
    @course = Course.find(params[:id])
  end

  def file_show
    @course = Course.find(params[:id])
    @file = @course.appfiles.find(params[:file_id])
    respond_to do |format|
     format.js {render :json => @file}
    end
  end

  def group_index
    @course = Course.find(params[:id])
    @unassigned_students = get_unassigned_students_for_course(@course.id)
  end

  ##TODO requires rigorous testing
  def group_assign
    @course = Course.find(params[:id])
    group_unassigned_students_by_course_id(@course.id) 
    respond_to do |format|
     format.html{redirect_to('/courses/'+@course.id.to_s+'/groups')}
    end

  end

  def group_assign_manual_new
    @course = Course.find(params[:id])
    @unassigned_students = get_unassigned_students_for_course(@course.id)
  end

  def group_assign_manual_create

    @course = Course.find(params[:id])
    @unassigned_students = get_unassigned_students_for_course(@course.id)
    logger.info 'HYD -> ' + params.inspect
    success = true
    message = 'Selected students grouped successfuly'

    if !(!params[:group_name].nil? && params[:group_name].length > 0)
      success = false
      message = 'Group Name cannot be blank'
    end
    selected_students = []
    logger.info 'HYD -> ' + params.keys.inspect
    if success == true
      for student in @unassigned_students
        groupable_id = 'groupable_id_'+student.id.to_s

        if !params[groupable_id.to_s].nil? 
          logger.info 'HYD ->' + student.username + 'selected for grouping'
          selected_students.push(student)
        end
      end
      if selected_students.count == 0
        success = false
        message = 'Please select a few student for grouping'
      end

    end
    if success
      group_unassigned_students(@course,selected_students,params[:group_name]) 
    end
    respond_to do |format|
     if success
      flash[:notice] = message
     else
      flash[:alert] = message
     end
     format.html{redirect_to('/courses/'+@course.id.to_s+'/groups/assign/manual')}
    end

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
        if @course_allocation.user_id.nil?
            flash[:alert] = 'There is no allocated teacher for this institute now.'
        end
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
    @assignment_solution = AssignmentSolution.find(:first,:limit => 1 ,:conditions => {:assignment_id => @assignment.id,:user_id => session[:user_id]})
    if @assignment_solution.nil?
      logger.info 'no solution found creating new one'
      @assignment_solution = AssignmentSolution.new
      @assignment_solution.build_appfile
    end

  end

  def assignment_solution_create

    @course = Course.find(params[:id])
    @assignment = Assignment.find(params[:ass_id])
    @assignment_solution = AssignmentSolution.new(params[:assignment_solution])
    @assignment_solution.assignment_id = @assignment.id
    @assignment_solution.user_id = session[:user_id]
    @current_assignment_solution = AssignmentSolution.find(:first,:limit => 1 ,:conditions => {:assignment_id => @assignment.id,:user_id => session[:user_id]})
    success = true
    if !@current_assignment_solution.nil?
        
       success = @current_assignment_solution.update_attributes(params[:assignment_solution])
       if success == true && !@assignment_solution.appfile.nil?
          Delayed::Job.enqueue(AppfileUploader.new(@assignment_appfile.appfile.id))
       end
       @assignment_solution = @current_assignment_solution
    else
       success = @assignment_solution.save
       if success == true && !@assignment_solution.appfile.nil?
         Delayed::Job.enqueue(AppfileUploader.new(@assignment_solution.appfile.id))
       end
    end
    respond_to do |format|
      if success
       format.html {redirect_to('/courses/'+@course.id.to_s+'/assignments/'+@assignment.id.to_s+'/solutions/'+@assignment_solution.id.to_s)}
      else
       format.html {render :action => "assignment_solution_new"}
      end
    end
      
    
  end

  def assignment_solution_show
    @course = Course.find(params[:id])
    @assignment = Assignment.find(params[:ass_id])
    @assignment_solution = AssignmentSolution.find(params[:sol_id])
  end
  def assignment_solution_edit
    @course = Course.find(params[:id])
    @assignment = Assignment.find(params[:ass_id])
    @assignment_solution = AssignmentSolution.find(params[:sol_id])
    @grade = request.path.end_with?('grade')
  end
  def assignment_solution_update
    
    @course = Course.find(params[:id])
    @assignment = Assignment.find(params[:ass_id])
    @assignment_solution = AssignmentSolution.find(params[:sol_id])
    success = true
    success = @assignment_solution.update_attributes(params[:assignment_solution]);
    respond_to do |format|
      if success
       format.html {redirect_to('/courses/'+@course.id.to_s+'/assignments/'+@assignment.id.to_s+'/solutions/'+@assignment_solution.id.to_s)}
      else
       format.html {render :action => "assignment_solution_edit"}
      end
    end
  end

  def evaluate_home
    @course = Course.find(params[:id])
    @assignment = Assignment.find(params[:ass_id])
    @solutions = AssignmentSolution.find(:all,:conditions => {:assignment_id => @assignment.id})
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
    if !bbb.save ##TODO what if this fails
      raise 'Exception saving bbb ' + bbb.inspect.to_s
    end
    Delayed::Job.enqueue(ChannelCreator.new(bbb.id))
    respond_to do |format|
     format.html{redirect_to('/courses/'+@course.id.to_s+'/channel')}  
    end

  end

  def forum
    @course = Course.find(params[:id])
  end

  def forum_new
    @course = Course.find(params[:id])
    if @course.forum.nil?
      forum = Forum.new
      forum.course_id = @course.id
      forum.name  = @course.name + ' Forum'  
      forum.description  = 'A forum for discussions on the course ' + @course.name
      forum.save ##TODO what if thje save fails
    end

    respond_to do |format|
      format.html{redirect_to('/courses/'+@course.id.to_s+'/forum')}
    end

  end

  def forum_topics_new
    @course = Course.find(params[:id])
    @topic = Topic.new  
  end

  def forum_topics_create
    @course = Course.find(params[:id])
    @topic = Topic.new(params[:topic])
    @topic.user_id = session[:user_id]
    @topic.forum_id = @course.forum.id

    respond_to do |format|
      if @topic.save
       format.html {redirect_to('/courses/'+@course.id.to_s+'/forum/topics/'+@topic.id.to_s)}
      else
       format.html {render :action => "forum_topics_new"}
      end
    end

  end

  def forum_topics_show
    @course = Course.find(params[:id])
    #TODO verify this topic is part of this forum only
    @topic = Topic.find(params[:topic_id])
    @post = Post.new
    
  end

  def forum_topics_create_post
    @course = Course.find(params[:id])
    #TODO verify this topic is part of this forum only
    @topic = Topic.find(params[:topic_id])
    @post = Post.new(params[:post])
    @post.user_id = session[:user_id]
    @post.topic_id = @topic.id
    respond_to do |format|
      if @post.save
       format.html {redirect_to('/courses/'+@course.id.to_s+'/forum/topics/'+@topic.id.to_s)}
      else
       flash[:alert] = 'Content cannot be blank'
       format.html {redirect_to('/courses/'+@course.id.to_s+'/forum/topics/'+@topic.id.to_s)}
      end
    end
    
  end

end
