class TaskController < ApplicationController
  before_filter :validate_institute_url,:validate_logged_in_status
  def search
   @tasks = Task.where("user_id = ? and task_type = ?" ,current_user.id,params[:task_type])
   logger.info(@tasks.inspect)
   respond_to do |format|
    format.js {render :json => @tasks.to_json}
    #TODO avoid html rendering her 
   end
  end
end
