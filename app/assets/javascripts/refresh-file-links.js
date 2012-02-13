  
  $(document).ready(function() {
    setInterval(function(){
      refresh_file_links();
    },5000);
  });
  function refresh_file_links() {
    var more_links_to_refresh =  false;
    $(".refresh").each(function(index){
      more_links_to_refresh =  true;
      var course = $(this).attr("data-course");
      var file = $(this).attr("data-file");
      var current_object = $(this);
      $.read(
        '/courses/{id}/files/{file_id}',
        {id : course,file_id : file},
        function(response) {
          if(response != null) {
            if(response.status !=null && response.status == 'FAILED') {
                current_object.attr("class","do-not-refresh");
            }
            scribd_file = response.scribd;
            if (scribd_file!=null) {
              scribd_file = scribd_file.scribd_file;
            }
            if (scribd_file != null) {
                onclick_text = "load_file('"+ scribd_file.scribd_id+ "','" + scribd_file.scribd_key + "'); return false;"
                current_object.attr("href","#");
                current_object.attr("onclick",onclick_text);
                current_object.attr("class","do-not-refresh");
              
            } else {
            s3_object = response.s3_object;
            if (s3_object != null && s3_object.s3_object !=null && s3_object.s3_object.url !=null) {
                current_object.attr("href",s3_object.s3_object.url);
            } 
             
            }
          }
        }
      );

     
    });   
  }
  
