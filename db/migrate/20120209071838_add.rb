class Add < ActiveRecord::Migration
  def up
    add_column :course_files, :s3_url, :string
  end

  def down
    add_column :course_files, :s3_url
  end
end
