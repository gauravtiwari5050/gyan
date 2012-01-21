class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.integer :course_id
      t.string :title
      t.text :detail
      t.integer :total_marks
      t.string :assignment_file
      t.string :scribd_id
      t.string :scribd_key

      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
