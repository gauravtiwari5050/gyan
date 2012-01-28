class MessageMailingJob < Struct.new(:message_id)
  def perform
    @message = Message.find(message_id)
    UserMailer.message_send(@message).deliver
  end
end
