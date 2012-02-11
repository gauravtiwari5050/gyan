class DepartmentController < ApplicationController
  impressionist
  before_filter :validate_institute_url
  before_filter :validate_logged_in_status
  #layout :choose_layout

  def choose_layout
    if action_name.to_s.start_with?('program')
      return 'program'
    else 
      return 'department'
    end
  end
  

  def show
    @department = Department.find(params[:id])
    respond_to do |format|
      format.html {render :action => "show"}
    end
  end

  def destroy
    @department = Department.find(params[:id])
    @department.destroy
    respond_to do |format|
     format.html { redirect_to('/departments') }  
    end
  end

  def index
    @departments = Department.find(:all,:conditions => {:institute_id => get_institute_id})
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    @department = Department.find(params[:id])
    respond_to do |format|
      if @department.update_attributes(params[:department])
        format.html {redirect_to('/departments/' + @department.id.to_s)}
      else
        format.html {render :action => "edit" }
      end
    end
  end

  # controller elements for programs
  def program_new
    @program = Program.new
    @department = Department.find(params[:id])
  end

  def program_show
    ##add condition to verify department_id as well
    @program = Program.find(params[:program_id])
    @department = Department.find(params[:id])
  end

  def program_index
    @programs = Program.find(:all ,:conditions => {:department_id => params[:id]})
    @department = Department.find(params[:id])
  end

  def program_create
    @program = Program.new(params[:program])
    @department = Department.find(params[:id])
    @program.department_id = @department.id
    respond_to do |format|
      if @program.save
        format.html {redirect_to('/departments/'+@department.id.to_s+'/programs/'+@program.id.to_s)}
      else
        format.html {render :action => "program_new"}
      end
    end
  end


end
