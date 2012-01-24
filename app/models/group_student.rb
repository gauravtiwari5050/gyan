class GroupStudent < ActiveRecord::Base
  belongs_to :course_group
  belongs_to :user
end
