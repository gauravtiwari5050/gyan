CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => 'AKIAIL6JEVUDWEVR2DVA',       # required
    :aws_secret_access_key  => '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',       # required
    :region                 => 'eu-west-1'  # optional, defaults to 'us-east-1'
  }
  config.fog_directory  = 'cloudclasshq'                     # required
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end
