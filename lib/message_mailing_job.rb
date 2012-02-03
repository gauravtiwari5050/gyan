class MessageMailingJob < Struct.new(:message_id)
  def perform
    @message = Message.find(message_id)
    if @message.email == true 
      send_email @message
    end
    if @message.sms == true 
      send_sms @message
    end
    if @message.facebook == true 
      send_facebook_message @message
    end
    if @message.twitter == true 
      send_twitter_message @message
    end
  end

  def send_email(message) 
    UserMailer.message_send(message).deliver
  end

  def send_sms(message)
    require 'net/http'
    #TODO send an email to user if his contact details are not complete ?
    mvayoo_user = GyanV1::Application.config.mvayoo_user
    mvayoo_pass = GyanV1::Application.config.mvayoo_pass
    mvayoo_id = GyanV1::Application.config.mvayoo_id
    user_id = message.to_user
    user = User.find(user_id)
    phone_number = user.contact_detail.phone
    
    url = "http://api.mVaayoo.com/mvaayooapi/MessageCompose?user=" + mvayoo_user +  ":"  + mvayoo_pass +"&senderID=" + mvayoo_id + "&receipientno=" + phone_number +"&msgtxt=" + message.subject + "&state=4"
    url = URI.escape(url)
    req = Net::HTTP.get_response(URI.parse(url))
    Delayed::Worker.logger.info 'response for message sending'
    Delayed::Worker.logger.info 'REQ.status ' + req.inspect.to_s
    Delayed::Worker.logger.info 'REQ.body ' + req.body.to_s
    
  end
  def send_facebook_message(message)
    
  end
  def send_twitter_message(message)
    
  end
end
