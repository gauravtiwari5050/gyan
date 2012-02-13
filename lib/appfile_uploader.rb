include Util
class AppfileUploader < Struct.new(:appfile_id)
  def perform
    appfile = Appfile.find(appfile_id)
    #first upload to s3,then to scribd,then delete the local copy
    s3_upload_success =  true
    begin
      upload_to_s3(appfile)
    rescue Exception => e
      Delayed::Worker.logger.info 'uploading to s3 failed due to ' + e.message
      s3_upload_success = false
    end
    scribd_upload_success = true
    begin
      upload_to_scribd(appfile)
    rescue Exception => e
      Delayed::Worker.logger.info 'uploading to scribd failed due to ' + e.message
      scribd_upload_success = false
    end

    if s3_upload_success == false || scribd_upload_success == false
      appfile.update_attribute(:status, 'FAILED')
    else
      appfile.update_attribute(:status, 'SUCCESS')
    end


    if s3_upload_success == false
      raise 'uploading to s3 failed for ' + appfile.inspect
    else
      file_url = 'public/' + appfile.content.to_s
      File.delete(file_url)
    end


  end

  def upload_to_s3(appfile)
    Delayed::Worker.logger.info 'uploading to s3'
    Delayed::Worker.logger.info appfile.content
    require 'rubygems'
    require 'fog'
    require 'active_support/time'
    
    Delayed::Worker.logger.info 'uploading'
    url = 'public/' + appfile.content.to_s
    Delayed::Worker.logger.info url
    
    s3_bucket = GyanV1::Application.config.aws_bucket
    s3_key = unique_id('cchqfile') + '-' + File.basename(url)
    if !appfile.s3_object.nil?  && !appfile.s3_object.key.nil?
      s3_key = appfile.s3_object.key
    end
    
    # create a connection
    connection = Fog::Storage.new(
      :provider               => 'AWS',       # required
      :aws_access_key_id      => GyanV1::Application.config.aws_access_key_id,       # required
      :aws_secret_access_key  => GyanV1::Application.config.aws_secret_access_key       # required
    )

    # First, a place to contain the glorious details
    directory = connection.directories.create(
      :key    => "cloudclasshq1", # globally unique name
      :public => true
    )

    # list directories

    # upload that resume
    

    file = directory.files.create(
      :key    => s3_key,
      :body   => File.open(url),
      :public => true
    )

    #p file.url(Time.now.next_month.end_of_month)
    Delayed::Worker.logger.info file.public_url
    s3_url =  file.public_url
    
    #in case the job fails due to some reason avoid multiple uploads
    if !appfile.s3_object.nil? 
      s3_object = appfile.s3_object
      if !s3_object.update_attributes(:key => s3_key,:url => s3_url ,:bucket => s3_bucket)
        raise 'error updating s3 object ' + s3_object.inspect 
      end
    else
       s3_object = S3Object.new
       s3_object.bucket = s3_bucket
       s3_object.key = s3_key
       s3_object.url = s3_url
       s3_object.s3able_id = appfile.id
       s3_object.s3able_type = appfile.class.to_s
       if !s3_object.save
        raise 'error saving s3 object ' + s3_object.inspect 
       end
    end

  end

  def upload_to_scribd(appfile)
    Delayed::Worker.logger.info 'uploading to scribd'
    Delayed::Worker.logger.info appfile.content
    content_url = appfile.content_url

    require 'rubygems'
    require 'rscribd'

    # Use your API key / secret here
 
    api_key = GyanV1::Application.config.scribd_api_key
    api_secret = GyanV1::Application.config.scribd_api_secret
    # Create a scribd object
    Scribd::API.instance.key = api_key
    Scribd::API.instance.secret = api_secret

    url = 'public/' + content_url.to_s
    Scribd::User.login GyanV1::Application.config.scribd_user,GyanV1::Application.config.scribd_pass
    # Upload the document from a file
    puts "Uploading a document ... "

    doc = Scribd::Document.upload(:file => url)
    puts "Done doc_id=#{doc.id}, doc_access_key=#{doc.access_key}"

    # Poll API until conversion is complete
    #while (doc.conversion_status == 'PROCESSING')
    #  puts "Document conversion is processing"
    #  sleep(2) # Very important to sleep to prevent a runaway loop that will get your app blocked
    #end
    puts "Document conversion is complete"

    # Edit various options of the document
    # Note you can also edit options before your doc is done converting
    doc.title = 'cloudclass document'
    doc.description = url
    doc.access = 'private'
    doc.language = 'en'
    doc.license = 'c'
    doc.tags = 'cloudclass'
    doc.show_ads = true
    doc.save

    scribd_file = ScribdFile.new
    scribd_file.appfile_id = appfile.id
    scribd_file.scribd_id = doc.id
    scribd_file.scribd_key = doc.access_key
    if !scribd_file.save
      raise 'error saving scribd object ' + scribd_file.inspect
    end


  end
end
