class CreateCourseGroups < ActiveRecord::Migration
  def self.up
    create_table :course_groups do |t|
      t.integer :course_id
      t.string :group_name

      t.timestamps
    end
  end

  def self.down
    drop_table :course_groups
  end
end
