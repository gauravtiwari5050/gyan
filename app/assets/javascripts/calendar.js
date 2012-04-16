$(document).ready(drawCalendar);
function drawCalendar() {
	var date = new Date();
	var d = date.getDate();
	var m = date.getMonth();
	var y = date.getFullYear();
  
	
	$('#calendar').fullCalendar({
		editable: true,        
        defaultView: 'month',
        height: 500,
        slotMinutes: 15,
        
        loading: function(bool){
            if (bool) 
                $('#loading').show();
            else 
                $('#loading').hide();
        },
        
        // a future calendar might have many sources.        
        eventSources: [{
            url: '/calendar/events',
            color: 'yellow',
            textColor: 'black',
            ignoreTimezone: false
        }],
        
        timeFormat: 'h:mm t{ - h:mm t} ',
        dragOpacity: "0.5",
        
        //http://arshaw.com/fullcalendar/docs/event_ui/eventDrop/
        eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc){
            updateEvent(event);
        },

        // http://arshaw.com/fullcalendar/docs/event_ui/eventResize/
        eventResize: function(event, dayDelta, minuteDelta, revertFunc){
            updateEvent(event);
        },

        // http://arshaw.com/fullcalendar/docs/mouse/eventClick/
        eventClick: function(event, jsEvent, view){
          //alert('clicked on event'); TODO add update/delete functionality here
          window.open('/calendar/events/'+event.id+'/edit');
          return false;
        },
        dayClick: function(date, allDay, jsEvent, view) {

        if (allDay) {
            current_date = $.datepicker.formatDate('yy-mm-dd', date); 
            $( "#dialog-form-event" ).attr('currrent-date',current_date);
            $( "#dialog-form-event" ).dialog( "open" );
        }


    },
	});
	$('#calendar_attendance').fullCalendar({
		editable: true,        
        defaultView: 'month',
        slotMinutes: 15,
        
        loading: function(bool){
            if (bool) 
                $('#loading').show();
            else 
                $('#loading').hide();
        },
        
        timeFormat: 'h:mm t{ - h:mm t} ',
        dragOpacity: "0.5",
        
        dayClick: function(date, allDay, jsEvent, view) {
          window.open('/courses/1/mark_attendance/'+date.getFullYear()+'-'+date.getMonth()+'-'+date.getDate()+'/LECTURE');
          return false;

        }


	});
}

function updateEvent(the_event) {
    $.update(
      "/events/" + the_event.id,
      { event: { title: the_event.title,
                 starts_at: "" + the_event.start,
                 ends_at: "" + the_event.end,
                 description: the_event.description
               }
      },
      function (reponse) { alert('successfully updated task.'); }
    );
};
