ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => "gaurav2gaurav@gmail.com",
  :password             => "ahambramhasmi",
  :authentication       => "plain",
  :enable_starttls_auto => false
}
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?

