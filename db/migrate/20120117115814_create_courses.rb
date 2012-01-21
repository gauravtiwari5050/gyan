class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.integer :institute_id
      t.string :name
      t.text :about
      t.string :code

      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
