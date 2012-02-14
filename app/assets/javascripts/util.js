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
    function updateTips( t ) {
      $( ".validateTips" )
        .text( t )
        .addClass( "ui-state-highlight" );
      setTimeout(function() {
        $( ".validateTips" ).removeClass( "ui-state-highlight", 1500 );
      }, 500 );
    }
