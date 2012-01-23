class CreateBbbs < ActiveRecord::Migration
  def self.up
    create_table :bbbs do |t|
      t.integer :course_id
      t.string :name
      t.string :meeting_id
      t.string :attendee_pw
      t.string :moderator_pw
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :bbbs
  end
end
