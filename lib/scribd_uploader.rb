class ScribdUploader < Struct.new(:obj,:location)
  def upload_to_scribd(content_url)
    puts 'uploading to scribd'
    puts content_url
    require 'rubygems'
    require 'rscribd'

    # Use your API key / secret here
 
    api_key = '4txwgemkqbmavpeam3eas'
    api_secret = 'sec-46jrulbuqetj2squ1046miv9sg'
    # Create a scribd object
    Scribd::API.instance.key = api_key
    Scribd::API.instance.secret = api_secret
    url = 'public/' + content_url.to_s
    Scribd::User.login 'gauravtiwari5050', 'harekrsna1!'
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
    doc.title = 'This is a test doc!'
    doc.description = "final"
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

  end
  
end
