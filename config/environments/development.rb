GyanV1::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  #upgrading to 3.1
  #config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  config.url_suffix = '.lvh.me:3000'
  config.landing_page = 'http://lvh.me:3000'
  config.aws_access_key_id = 'AKIAIS236FU4P4W6YPYQ'
  config.aws_secret_access_key  = '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'
  config.aws_bucket = 'cloudclasshq1'
  config.scribd_api_key = '4txwgemkqbmavpeam3eas'
  config.scribd_api_secret = 'sec-46jrulbuqetj2squ1046miv9sg'
  config.scribd_user = 'gauravtiwari5050'
  config.scribd_pass = 'ixrt9Bth'
  config.mvayoo_user = 'gaurav2gaurav@gmail.com'
  config.mvayoo_pass = 'Allahabad1!'
  config.mvayoo_id = 'TEST SMS'
  config.sms_easy_userid = 'CLASS'
  config.sms_easy_pass = '816Rbo92'
  config.sms_easy_senderid = 'CCLASS'

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
  #config.middleware.use ExceptionNotifier,
  #:email_prefix => "[Exception] ",
  #:sender_address => %{"Exception Notifier" <gauravt@cloudclasshq.com>},
  #:exception_recipients => %w{gaurav2gaurav@gmail.com}
end

