function createUser(username,email,usertype,modal_dialog_obj) {
            var post_url = 'admin/teachers/add';
            if(usertype == 'STUDENT') {
              post_url = 'admin/students/add';
            }
              $.create(
                post_url,
                {user_email:email,user_name:username},
                  function(response) {
                  updateTips("User created successfuly.");  
                  if(modal_dialog_obj!=null) {
                    setTimeout(function() {
                      modal_dialog_obj.dialog("close");
                    }, 1500 );
                    
                  }

                  },
                  function(error) {
                  updateTips("Error creating user");  
                  }
                );
}

function createAnnouncement(title,content,course_id,modal_dialog_obj) {
              $.create(
                '/courses/' + course_id  + '/announcements/create',
                {course_announcement:{title:title,details:content},id:course_id},
                  function(response) {
                  updateTips("Announcement posted successfuly..");  
                  if(modal_dialog_obj!=null) {
                    setTimeout(function() {
                      modal_dialog_obj.dialog("close");
                    }, 1500 );
                    
                  }

                  },
                  function(error) {
                  updateTips("Error posting your announcement ,please try again later");  
                  }
                );
    
}
function createEvent(event_title,event_description,current_date,start_time,end_time,modal_dialog_obj) {
//alert(title + " " + description + " " + current_date + " " +  start_time + " " + end_time);
start_time = current_date + " " + start_time;
end_time = current_date + " " + end_time;
              $.create(
                '/calendar/events/create',
                {event:{title:event_title,description:event_description,starts_at:start_time,ends_at:end_time}},
                  function(response) {
                  updateTips("Event created successfuly");  
                  if(modal_dialog_obj!=null) {
                    setTimeout(function() {
                      modal_dialog_obj.dialog("close");
                      $('#calendar').html("");
                      drawCalendar();
                    }, 1500 );
                    
                  }

                  },
                  function(error) {
                  updateTips("Error creating event ,please try again later");  
                  }
                );
}

function createMessage(subject,message,to_user,modal_dialog_obj) {
  $.create(
    '/users/' + user_id +'/message/create',
    {message:{subject:subject,content:message,email:1,sms:0,facebook:0,twitter:0},user_id:user_id},
    function(response) {
                  updateTips("Message sent successfuly");  
                  if(modal_dialog_obj!=null) {
                    setTimeout(function() {
                      modal_dialog_obj.dialog("close");
                    }, 1500 );
                    }
      
    },
    function(response) {
     updateTips("Error creating event ,please try again later");  
    }
  );  
}
    function updateTips( t ) {
      $( ".validateTips" )
        .text( t )
        .addClass( "ui-state-highlight" );
      setTimeout(function() {
        $( ".validateTips" ).removeClass( "ui-state-highlight", 1500 );
      }, 500 );
    }
