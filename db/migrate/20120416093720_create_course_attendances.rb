class CreateCourseAttendances < ActiveRecord::Migration
  def change
    create_table :course_attendances do |t|
      t.integer :course_id
      t.integer :student_id
      t.date :date
      t.string :type

      t.timestamps
    end
  end
end
