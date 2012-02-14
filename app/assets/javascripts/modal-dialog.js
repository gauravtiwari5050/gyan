var user_type = 'STUDENT';
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
              /*
              $.create(
                'admin/teachers/add',
                {user_email:email,user_name:username},
                  function(response) {
                  updateTips("User created successfuly.");  
                  },
                  function(error) {
                  updateTips("Error creating user");  
                  alert("error");
                  }
                );
                */
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
