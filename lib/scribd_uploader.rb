class ScribdUploader < Struct.new(:obj,:location)
  def upload_to_s3(obj,content_url)
    Delayed::Worker.logger.info 'uploading to s3'
    Delayed::Worker.logger.info content_url
    require 'rubygems'
    require 'fog'
    require 'active_support/time'
    
    Delayed::Worker.logger.info 'uploading'
    url = 'public/' + content_url.to_s
    Delayed::Worker.logger.info url
    
    s3_bucket = GyanV1::Application.config.aws_bucket
    s3_key = unique_id('cchqfile') + '-' + File.basename(url)
    if !obj.s3_object.nil?  && !obj.s3_object.key.nil?
      s3_key = obj.s3_object.key
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
    if !obj.s3_object.nil? 
      s3_object = obj.s3_object
      s3_object.update_attributes(:key => s3_key,:url => s3_url ,:bucket => s3_bucket)
    else
       s3_object = S3Object.new
       s3_object.bucket = s3_bucket
       s3_object.key = s3_key
       s3_object.url = s3_url
       s3_object.s3able_id = obj.id
       s3_object.s3able_type = obj.class.to_s
       s3_object.save
    end

  end


  def upload_to_scribd(content_url)
    puts 'uploading to scribd'
    puts content_url
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
    doc.title = 'cchq document'
    doc.description = url
    doc.access = 'private'
    doc.language = 'en'
    doc.license = 'c'
    doc.tags = 'test,api'
    doc.show_ads = true
    doc.save

    return doc.id,doc.access_key
  rescue
    puts "couldnt upload to scribd"
    return nil,nil
  end

  #gets ids from an array of model objects
  
  def perform
    #first upload to s3,then to scribd,then delete the local copy
    s3_upload_success =  true
    begin
      upload_to_s3(obj,location)
    rescue
      Delayed::Worker.logger.info 'uploading to s3 failed'
      s3_upload_success = false
    end

    #TODO correct the logic for saving
    id,key = upload_to_scribd(location)
    Delayed::Worker.logger.info 'id' + id.to_s
    Delayed::Worker.logger.info 'key' + key.to_s
    if !obj.update_attribute(:scribd_id , id.to_s)
      raise 'unable to save'
    end
    if !obj.update_attribute(:scribd_key , key.to_s)
      raise 'unable to save'
    end

    if s3_upload_success == true
      file_url = 'public/' + location.to_s
      File.delete(file_url)
    end

  end

  def unique_id(prefix)
    require 'uuidtools'
    return  prefix.to_s + UUIDTools::UUID.timestamp_create.to_s
  end 
  
end
