class CreateCourseAllocations < ActiveRecord::Migration
  def self.up
    create_table :course_allocations do |t|
      t.integer :course_id
      t.integer :program_id
      t.integer :term
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :course_allocations
  end
end
