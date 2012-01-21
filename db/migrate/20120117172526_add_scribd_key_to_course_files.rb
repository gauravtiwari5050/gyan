class AddScribdKeyToCourseFiles < ActiveRecord::Migration
  def self.up
    add_column :course_files, :scribd_key, :string
  end

  def self.down
    remove_column :course_files, :scribd_key
  end
end
