class CreateGroupStudents < ActiveRecord::Migration
  def self.up
    create_table :group_students do |t|
      t.integer :course_group_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :group_students
  end
end
