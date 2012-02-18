var user_type = 'STUDENT';
var current_date = '';
var user_id = '';
var username = '';
  $(function() {
    $( "#dialog-form-user" ).dialog({
      
      autoOpen: false,
      height: 300,
      width: 350,
      modal: true,
      buttons: {
        "Create an account": function() {
            var username = $("#modal-username");
            var email = $("#modal-email");
            var bValid = true;
            bValid = bValid && checkLength( username, "username", 3, 16 );
            bValid = bValid && checkLength( email, "email", 6, 80 );
            bValid = bValid && validateEmail(email);

          if ( bValid ) {
              updateTips("Creating user.Please wait ..");  
              createUser(username.val(),email.val(),user_type,$(this));
           }
        },
        Cancel: function() {
          $( this ).dialog( "close" );
        }
      },
      close: function() {
        $("#modal-username").val("");
        $("#modal-email").val("");
      }
    });

    $( "#dialog-form-announcement" ).dialog({
      
      autoOpen: false,
      height: 300,
      width: 350,
      modal: true,
      buttons: {
        "Announce": function() {
            var subject = $("#modal-subject");
            var announcement = $("#modal-announcement");
            var bValid = true;
            bValid = bValid && checkLength( subject, "subject", 3, 10 );
            bValid = bValid && checkLength( announcement, "announcement", 6, 80 );
            if ( bValid ) {
              createAnnouncement(subject.val(),announcement.val(),$(this).attr("data-course"),$(this));
            }

        },
        Cancel: function() {
          $( this ).dialog( "close" );
        }
      },
      close: function() {
        $("#modal-subject").val("");
        $("#modal-announcement").val("");
      }
    });
    $( "#dialog-form-announcement_dep" ).dialog({
      
      autoOpen: false,
      height: 300,
      width: 350,
      modal: true,
      buttons: {
        "Announce": function() {
            var subject = $("#modal-subject");
            var announcement = $("#modal-announcement");
            var bValid = true;
            bValid = bValid && checkLength( subject, "subject", 3, 10 );
            bValid = bValid && checkLength( announcement, "announcement", 6, 80 );
            if ( bValid ) {
              createAnnouncementForDepartment(subject.val(),announcement.val(),$(this).attr("data-dep"),$(this));
            }

        },
        Cancel: function() {
          $( this ).dialog( "close" );
        }
      },
      close: function() {
        $("#modal-subject").val("");
        $("#modal-announcement").val("");
        location.reload();
      }
    });
    $( "#dialog-form-message" ).dialog({
      
      autoOpen: false,
      height: 300,
      width: 350,
      modal: true,
      buttons: {
        "Send": function() {
            var subject = $("#modal-subject");
            var message = $("#modal-message");
            var bValid = true;
            bValid = bValid && checkLength( subject, "subject", 3, 10 );
            bValid = bValid && checkLength( message, "message", 6, 80 );
            if ( bValid ) {
              createMessage(subject.val(),message.val(),user_id,$(this));
            }

        },
        Cancel: function() {
          $( this ).dialog( "close" );
        }
      },
      close: function() {
        $("#modal-subject").val("");
        $("#modal-message").val("");
      }
    });
    $( "#dialog-form-event" ).dialog({
      
      autoOpen: false,
      height: 300,
      width: 350,
      modal: true,
      buttons: {
        "Add event": function() {
        var title = $("#modal-title");
        var description = $("#modal-description");
        var start_time = $("#modal-start_time");
        var end_time = $("#modal-end_time");
        //bad way to pass around in global vars #TODO remove this
        
        var bValid = true;
        bValid = bValid && checkLength( title, "event title", 1, 10 );
        bValid = bValid && checkLength( description, "event description", 1, 200 );
        bValid = bValid && checkLength( start_time, "start time", 1, 10 );
        bValid = bValid && checkLength( end_time, "end time", 1, 10 );
        if(bValid) {
          createEvent(title.val(),description.val(),current_date,start_time.val(),end_time.val(),$(this));
        }

        },
        Cancel: function() {
          $( this ).dialog( "close" );
        }
      },
      close: function() {
        $("#modal-title").val("");
        $("#modal-description").val("");
        $("#modal-start_time").val("");
        $("#modal-end_time").val("");
      }
    });


    $( ".add-student" )
      .click(function() {
        user_type = 'STUDENT';
        $( "#dialog-form-user" ).dialog( "open" );
      });
    $( ".add-teacher" )
      .click(function() {
        user_type = 'TEACHER';
        $( "#dialog-form-user" ).dialog( "open" );
      });
    $( ".add-announcement" )
      .click(function() {
        $( "#dialog-form-announcement" ).dialog( "open" );
      });
    $( ".add-announcement_dep" )
      .click(function() {
        $( "#dialog-form-announcement_dep" ).dialog( "open" );
      });
  
  
  });

  function validateEmail(email) {
          return checkRegexp( email, /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i ,"Invalid email format eg. ui@xyz.com");
  
  }

    function checkRegexp( o, regexp,n ) {
      if ( !( regexp.test( o.val() ) ) ) {
        o.addClass( "ui-state-error" );
        updateTips( n );
        return false;
      } else {
        return true;
      }
    }
    
    function checkLength( o, n, min, max ) {
      if ( o.val().length > max || o.val().length < min ) {
        o.addClass( "ui-state-error" );
        updateTips( "Length of " + n + " must be between " +
          min + " and " + max + "." );
        return false;
      } else {
        return true;
      }
    }

    function modal_message_create(name,uid) {
      username = name;
      user_id = uid;
      alert(username + user_id); 
      $('#modal-username').html('<b>' + username  +  '</b>')
      $( "#dialog-form-message" ).dialog( "open" );
    }

