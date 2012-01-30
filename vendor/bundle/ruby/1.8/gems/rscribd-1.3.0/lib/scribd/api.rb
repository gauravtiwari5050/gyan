require 'singleton'
require 'digest/md5'
require 'rexml/document'

module Scribd
  
  # This class acts as the top-level interface between Scribd and your
  # application. Before you can begin using the Scribd API, you must specify for
  # this object your API key and API secret. They are available on your account
  # settings page.
  #
  # This class is a singleton. Its only instance is accessed using the
  # @instance@ class method.
  #
  # To begin, first specify your API key and secret:
  #
  # <pre><code>
  # Scribd::API.instance.key = 'your API key here'
  # Scribd::API.instance.secret = 'your API secret here'
  # </code></pre>
  #
  # (If you set the @SCRIBD_API_KEY@ and @SCRIBD_API_SECRET@ Ruby environment
  # variables before loading the gem, these values will be set automatically for
  # you.)
  #
  # Next, you should log in to Scribd, or create a new account through the gem.
  #
  # <pre><code>user = Scribd::User.login 'login', 'password'</code></pre>
  #
  # You are now free to use the {Scribd::User} or {Scribd::Document} classes to
  # work with Scribd documents or your user account.
  #
  # If you need the {User} instance for the currently logged in user at a later
  # point in time, you can retrieve it using the @user@ attribute:
  #
  # <pre><code>user = Scribd::API.instance.user</code></pre>
  #
  # In addition, you can save and restore sessions by simply storing this user
  # instance and assigning it to the API at a later time. For example, to
  # restore the session retrieved in the previous example:
  #
  # <pre><code>Scribd::API.instance.user = user</code></pre>
  #
  # In addition to working with Scribd users, you can also work with your own
  # website's user accounts. To do this, set the Scribd API user to a string
  # containing a unique identifier for that user (perhaps a login name or a user
  # ID):
  #
  # <pre><code>Scribd::API.instance.user = my_user_object.mangled_user_id</code></pre>
  #
  # A "phantom" Scribd user will be set up with that ID, so any documents you
  # upload will be associated with that account.
  #
  # For more hints on what you can do with the Scribd API, please see the
  # {Document} class.
  
  class API
    include Singleton

    # @private
    HOST = 'api.scribd.com'
    # @private
    PORT = 80
    # @private
    REQUEST_PATH = '/api'
    # @private
    TRIES = 3

    # @return [String] The API key you were given when you created a Platform account.
    attr_accessor :key
    # @return [String] The API secret used to validate your key (also provided with your account).
    attr_accessor :secret
    # @return [Scribd::User] The currently logged in user.
    attr_accessor :user
    # @return [true, false] If true, requests are processed asynchronously. If false, requests are blocking.
    attr_accessor :asynchronous
    # @return [true, false] If true, extended debugging information is printed
    attr_accessor :debug

    # @private
    def initialize
      @asychronous = false
      @key = ENV['SCRIBD_API_KEY']
      @secret = ENV['SCRIBD_API_SECRET']
      @user = User.new
      disable_multipart_post_gem
    end

    def enable_multipart_post_gem
      require 'net/http/post/multipart'
      require File.expand_path('../../support/buffered_upload_io', __FILE__)
      @use_multipart_post_gem = true
    end

    def disable_multipart_post_gem
      @use_multipart_post_gem = false
    end

    # @private
    def send_request(method, fields={})
      raise NotReadyError unless @key and @secret
      # See if method is given
      raise ArgumentError, "Method should be given" if method.nil? || method.empty?
      
      debug("** Remote method call: #{method}; fields: #{fields.inspect}")
      
      # replace pesky hashes to prevent accidents
      fields = fields.stringify_keys

      # Complete fields with the method name
      fields['method'] = method
      fields['api_key'] = @key
      
      if fields['session_key'].nil? and fields['my_user_id'].nil? then
        if @user.kind_of? Scribd::User then
          fields['session_key'] = @user.session_key
        elsif @user.kind_of? String then
          fields['my_user_id'] = @user
        end
      end
      
      fields.reject! { |k, v| v.nil? }

      # Don't include file in parameters to calculate signature
      sign_fields = fields.dup
      sign_fields.delete 'file'

      fields['api_sig'] = sign(sign_fields)
      debug("** POST parameters: #{fields.inspect}")

      res = send_request_to_scribd(fields)

      debug "** Response:"
      debug(res.body)
      debug "** End response"

      # Convert response into XML
      xml = REXML::Document.new(res.body)
      raise MalformedResponseError, "The response received from the remote host could not be interpreted" unless xml.elements['/rsp']

      # See if there was an error and raise an exception
      if xml.elements['/rsp'].attributes['stat'] == 'fail'
        # Load default code and error
        code, message = -1, "Unidentified error:\n#{res.body}"

        # Get actual error code and message
        err = xml.elements['/rsp/error']
        code, message = err.attributes['code'], err.attributes['message'] if err

        # Add more data
        message = "Method: #{method} Response: code=#{code} message=#{message}"

        raise ResponseError.new(code), message
      end

      return xml
    end

    private 

    def send_request_to_scribd(fields)
      # Create the connection
      http = Net::HTTP.new(HOST, PORT)
      # TODO configure timeouts through the properties

      # API methods can be SLOW.  Make sure this is set to something big to prevent spurious timeouts
      http.read_timeout = 15*60

      request = request_using_multipart_post_gem(fields) || request_using_supplied_multipart_post(fields)

      tries = TRIES
      begin
        tries -= 1
        res = http.request(request)
      rescue Exception
        $stderr.puts "Request encountered error, will retry #{tries} more."
        if tries > 0
          # Retrying several times with sleeps is recommended.
          # This will prevent temporary downtimes at Scribd from breaking API applications
          sleep(20)
          retry
        end
        raise $!
      end

    ensure
      http.finish if http && http.started?
    end

    def request_using_supplied_multipart_post(fields)
      request = Net::HTTP::Post.new(REQUEST_PATH)
      request.multipart_params = fields
      request
    end

    def request_using_multipart_post_gem(fields)
      return nil unless @use_multipart_post_gem

      fields = fields.dup
      original_file_value = fields['file']
      if original_file_value
        filename = File.basename(original_file_value.path)
        mime_types = MIME::Types.of(filename)
        mime_type = mime_types.empty? ? "application/octet-stream" : mime_types.first.content_type

        fields['file'] = BufferedUploadIO.new(original_file_value, mime_type, filename)
      end
      Net::HTTP::Post::Multipart.new(REQUEST_PATH, fields)
    end

    # FIXME: Since we don't need XMLRPC, the exception could be different
    # TODO: It would probably be better if we wrapped the fault
    # in something more meaningful. At the very least, a broad
    # division of errors, such as retryable and fatal. 
    def error(el)
      att = el.attributes
      fe = XMLRPC::FaultException.new(att['code'].to_i, att['msg'])
      $stderr.puts "ERR: #{fe.faultString} (#{fe.faultCode})"
      raise fe
    end

    # Checks if a string parameter is given and not empty.
    # 
    # Parameters:
    #   name  - parameter name for an error message.
    #   value - value.
    #   
    # Raises:
    #   ArgumentError if the value is nil, or empty.
    #
    def check_not_empty(name, value)
      check_given(name, value)
      raise ArgumentError, "#{name} must not be empty" if value.to_s.empty?
    end

    # Checks if the value is given.
    #
    # Parameters:
    #   name  - parameter name for an error message.
    #   value - value.
    #   
    # Raises:
    #   ArgumentError if the value is nil.
    #
    def check_given(name, value)
      raise ArgumentError, "#{name} must be given" if value.nil?
    end
    
    # Sign the arguments hash with our very own signature.
    #
    # Parameters:
    #   args - method arguments to be sent to the server API
    # 
    # Returns:
    #   signature
    #
    def sign(args)
      return Digest::MD5.hexdigest(@secret + args.sort.flatten.join).to_s
    end
    
    # Outputs whatever is given into the $stderr if debugging is enabled.
    #
    # Parameters:
    #   args - content to output
    def debug(str)
      $stderr.puts(str) if @debug
    end
  end

end
