
require 'rubygems'
require 'spreadsheet'
require 'resolv'

include Util

class CreateUserFromFileJob < Struct.new(:file_url,:task_obj,:user_type,:institute_id)
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
  
  @workbook = Spreadsheet.open file_url
  invalid_emails = []
  valid_but_errored_emails = []
  for worksheet in @workbook.worksheets
    worksheet.each do |row|
      row.each do |element|
        if validate_email_domain(element) == true
          p element + 'is a valid email'
          user = create_vanilla_user(element,user_type,institute_id)
          begin
            user.save
          rescue
            valid_but_errored_emails.push(emails)
          end
        else
          p element + 'is a invalid email'
          invalid_emails.push(element)
        end
      end
    end
  end

  if invalid_emails.length == 0 && valid_but_errored_emails.length == 0
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
    
  end
end
