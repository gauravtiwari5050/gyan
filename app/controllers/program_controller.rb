class ProgramController < ApplicationController
  impressionist
  before_filter :validate_institute_url
  before_filter :validate_program_access
  def show
    @program = Program.find(params[:id])
  end
  def course_new
    @program = Program.find(params[:id])
    @helper_program_course = HelperProgramCourse.new
  end

  def course_create
    @program = Program.find(params[:id])
    @helper_program_course = HelperProgramCourse.new(params[:helper_program_course])
    @course = Course.new
    @course_allocation = CourseAllocation.new
    persist_success =  true
    begin
      HelperProgramCourse.transaction do
        @course.name = @helper_program_course.course_name
        @course.code = get_institute_id.to_s + "_" + @helper_program_course.course_code
        @course.about = @helper_program_course.course_about
        @course.institute_id = get_institute_id
        @course.save

        @course_allocation.course_id = @course.id
        @course_allocation.program_id = @program.id
        @course_allocation.term = @helper_program_course.course_term

        @course_allocation.save
      end
    rescue Exception => e
        @helper_program_course.errors.add('course_name',e.message)
        persist_success = false
    end
    
    if persist_success
      respond_to do|format|
        format.html {redirect_to('/courses/'+@course.id.to_s+'/home')}
      end
    else
      respond_to do|format|
        format.html {render :action => "course_new"}
      end
      
    end

  end

  def course_index
    @program = Program.find(params[:id])
    @course_allocations =  CourseAllocation.find(:all,:conditions => {:program_id => @program.id}) 
    course_ids  = []
    for ca in @course_allocations
      course_ids.push(ca.course_id)
    end

    @courses = Course.find(:all,:conditions => {:id => course_ids})

  end
end
