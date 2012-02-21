class CollaborationJob < Struct.new(:etherpad_id)
  def perform
   etherpad = Etherpad.find(etherpad_id)
   url = 'http://'+etherpad.server+'/api/1/createPad?apikey=n3yFoCq1b8RgaucXSMMV0d5yKgBG6edU&padID='+etherpad.name
   Delayed::Worker.logger.info 'URL ' + url
   req = Net::HTTP.get_response(URI.parse(url))
   Delayed::Worker.logger.info 'REQ.status ' + req.inspect.to_s
   Delayed::Worker.logger.info 'REQ.body ' + req.body.to_s
   etherpad.update_attribute(:status,'RUNNING')
  end
  
end
