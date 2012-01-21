class CreateCourseFiles < ActiveRecord::Migration
  def self.up
    create_table :course_files do |t|
      t.integer :course_id
      t.string :name
      t.string :content

      t.timestamps
    end
  end

  def self.down
    drop_table :course_files
  end
end
