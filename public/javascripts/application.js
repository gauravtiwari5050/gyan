// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function load_file(id,key) {
  var scribd_doc = scribd.Document.getDoc( id, key );

  var oniPaperReady = function(e){
  // scribd_doc.api.setPage(3);
  }

  scribd_doc.addParam( 'jsapi_version', 1 );
  scribd_doc.addEventListener( 'iPaperReady', oniPaperReady );
  scribd_doc.write( 'embedded_flash' );
}
