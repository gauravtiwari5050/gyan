class MailingJob < Struct.new(:user_id)
  def perform
    @user = User.find(user_id)
    UserMailer.registration_confirmation(@user).deliver
  end
end
