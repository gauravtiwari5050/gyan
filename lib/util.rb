module Util
  def create_vanilla_user(email,user_type,institute_id)
    user = User.new
    user.institute_id = institute_id
    user.email = email
    user.user_type = user_type
    user.one_time_login = unique_id('')
    user.is_validated = false
    return user
  end
  
  def unique_id(prefix)
  require 'uuidtools'
    return  prefix.to_s + UUIDTools::UUID.timestamp_create.to_s
  end
end
