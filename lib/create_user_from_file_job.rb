
require 'rubygems'
require 'spreadsheet'
require 'resolv'

include Util

class CreateUserFromFileJob < Struct.new(:file_url,:task_id,:user_type,:institute_id)
  def validate_email_domain(email)
      p email
      status = true
      if email.nil?
        status = false
      end
      begin
        domain = email.match(/\@(.+)/)[1]
        Resolv::DNS.open do |dns|
          @mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
        end
        status = @mx.size > 0 ? true : false
      rescue
        status =  false
      end
      return status
  end
  def perform
  Delayed::Worker.logger.info 'Creating emails from file : ' + file_url 
  invalid_emails = []
  valid_but_errored_emails = []
  success =  true
  begin
    @workbook = Spreadsheet.open file_url
    for worksheet in @workbook.worksheets
      worksheet.each do |row|
        row.each do |element|
          if validate_email_domain(element) == true
            Delayed::Worker.logger.info element + 'is a valid email'
            user = create_vanilla_user(element,user_type,institute_id)
            begin
              user.save
              UserMailer.registration_confirmation(user).deliver
            rescue
              Delayed::Worker.logger.info 'error creating user with email ' + element
              valid_but_errored_emails.push(element)
            end
          else
            Delayed::Worker.logger.info element + 'is a invalid email'
            invalid_emails.push(element)
          end
        end
      end
    end

  rescue Exception => e
   success = false 
   Delayed::Worker.logger.info e.message
   Delayed::Worker.logger.info e.backtrace.inspect

  end
  task_obj = Task.find(task_id)
  if success == false
    task_obj.update_attributes(:completion_status => 'COMPLETE',:execution_status => 'FAILED',:output => 'Invalid File format/structure') 
  elsif invalid_emails.length == 0 && valid_but_errored_emails.length == 0
    task_obj.update_attributes(:completion_status => 'COMPLETE',:execution_status => 'SUCCESS') 
  else
    error_message = '<p> The following emails were invalid </p>';
    error_message += '<ul>';
    invalid_emails.each do |invalid_email|
      error_message += '<li>' +  invalid_email.to_s + '</li>';
    end
    error_message += '</ul>';
    error_message += '</br>';
    error_message += '<p> There were problems adding the following users,probably the emails are not unique </p>';
    error_message += '<ul>';
    valid_but_errored_emails.each do |invalid_email|
      error_message += '<li>' +  invalid_email.to_s + '</li>';
    end
    error_message += '</ul>';
    error_message += '</br>';

    task_obj.update_attributes(:completion_status => 'COMPLETE',:execution_status => 'WARN',:output => error_message) 
  end
  Delayed::Job.enqueue(ObjectDestroyJob.new(task_obj.class.to_s,task_obj.id),:run_at => 30.seconds.from_now)
  end
end
