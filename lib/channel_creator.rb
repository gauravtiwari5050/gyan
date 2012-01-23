class ChannelCreator < Struct.new(:bbb_id)
  def perform
    bbb = Bbb.find(bbb_id)
    params = 'name='+bbb.name
    params += '&'
    params+= 'meetingID='+bbb.meeting_id
    params+= '&'
    params+= 'attendeePW='+bbb.attendee_pw
    params+= '&'
    params+= 'moderatorPW='+bbb.moderator_pw
    Delayed::Worker.logger.info 'PARAMs - ' + params
    checksum_input = 'create'+params+'77d3ed90b49520239acf9eb2dccd0a04'
    Delayed::Worker.logger.info 'CHECKSUM INPUT - ' + checksum_input
    checksum = Digest::SHA1.hexdigest checksum_input
    Delayed::Worker.logger.info 'CHECKSUM - ' + checksum
    create_url ='http://178.79.183.87/bigbluebutton/api/create?'+params+'&checksum='+checksum
    Delayed::Worker.logger.info 'CREATE_URL - ' + create_url
    req = Net::HTTP.get_response(URI.parse(create_url))

    Delayed::Worker.logger.info 'REQ.status ' + req.inspect.to_s
    Delayed::Worker.logger.info 'REQ.body ' + req.body.to_s
    bbb.update_attribute(:status,'RUNNING')
  end

end
