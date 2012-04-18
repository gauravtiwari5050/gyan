class FixColumnTypeOf < ActiveRecord::Migration
  def change
    rename_column :course_attendances, :type, :class_type
    rename_column :course_attendances, :student_id, :user_id
  end
end
