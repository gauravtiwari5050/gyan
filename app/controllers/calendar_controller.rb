class CalendarController < ApplicationController
  before_filter :validate_institute_url
  def home
  end
  def events_new
   @event = Event.new
  end

  def events_create
    @event = Event.new(params[:event])
    @event.user_id = session[:user_id]

    respond_to do |format|
      if @event.save
        format.html { redirect_to('/calendar', :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def events_show
    @event = Event.find(params[:event_id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
      format.js { render :json => @event.to_json }
    end
  end
 
 def events_index  

    @events = Event.find(:all,:conditions => {:user_id => session[:user_id]})
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
      format.js  { render :json => @events }
    end
  end

end
