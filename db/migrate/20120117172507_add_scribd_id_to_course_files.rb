class AddScribdIdToCourseFiles < ActiveRecord::Migration
  def self.up
    add_column :course_files, :scribd_id, :string
  end

  def self.down
    remove_column :course_files, :scribd_id
  end
end
