class SmsAlertJob < Struct.new(:message,:phone)

  def perform
    userid = GyanV1::Application.config.sms_easy_userid
    pass = GyanV1::Application.config.sms_easy_pass
    sender_id = GyanV1::Application.config.sms_easy_senderid
    url = "http://203.122.58.168/prepaidgetbroadcast/PrepaidGetBroadcast?userid=" + userid +"&pwd=" + pass + "&msgtype=s&ctype=1&sender=" + sender_id + "&pno=91" + phone + "&msgtxt=&alert=1"
    url = URI.escape(url)
    Delayed::Worker.logger.info 'Sending message ' + url
    req = Net::HTTP.get_response(URI.parse(url))
    Delayed::Worker.logger.info 'response for message sending'
    Delayed::Worker.logger.info 'REQ.status ' + req.inspect.to_s
    Delayed::Worker.logger.info 'REQ.body ' + req.body.to_s
    
  end
end
