class CreateCourseAnnouncements < ActiveRecord::Migration
  def self.up
    create_table :course_announcements do |t|
      t.integer :course_id
      t.string :title
      t.text :details

      t.timestamps
    end
  end

  def self.down
    drop_table :course_announcements
  end
end
