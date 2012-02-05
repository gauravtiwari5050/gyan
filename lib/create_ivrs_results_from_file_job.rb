class CreateIvrsResultsFromFileJob < Struct.new(:file_url,:task_id,:ivrs_info_id)
  def perform
    success =  true
    Delayed::Worker.logger.info 'Creating results for IVRS : ' + file_url 
    begin
      ivrs_info = IvrsInfo.find_by_id(ivrs_info_id)
      if ivrs_info.nil?
        #TODO add exception notification her
        Delayed::Worker.logger.info 'IVRS INFO was nil while creating results'
        raise 'IVRS INFO was nil while creating results'
      end
      @workbook = Spreadsheet.open file_url
      for worksheet in @workbook.worksheets
        worksheet.each do |row|
          if row.length != 2
            raise 'Invalid file'
          end
          serial_number = Integer(row[0])
          score = row[1]

          ivrs_result =  IvrsResult.find_by_serial_number(serial_number)
          if ivrs_result.nil?
           ivrs_result = IvrsResult.new
           ivrs_result.ivrs_info_id = ivrs_info_id
           ivrs_result.serial_number = serial_number
           ivrs_result.score = score
           #TODO if one fails the entire job would fail
           ivrs_result.save
          else
            ivrs_result.update_attribute(:score,score)
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
      task_obj.update_attributes(:completion_status => 'COMPLETE',:execution_status => 'FAILED',:output => 'Invalid File format/structure.Please make sure the file has correct structure') 
    else
      task_obj.update_attributes(:completion_status => 'COMPLETE',:execution_status => 'SUCCESS',:output => "Results updated and are available through IVRS") 
    end
    Delayed::Job.enqueue(ObjectDestroyJob.new(task_obj.class.to_s,task_obj.id),:run_at => 30.seconds.from_now)
    
  end
end
