class CreateHelperProgramCourses < ActiveRecord::Migration
  def self.up
    create_table :helper_program_courses do |t|
      t.string :course_name
      t.string :course_code
      t.text :course_about
      t.integer :course_term

      t.timestamps
    end
  end

  def self.down
    drop_table :helper_program_courses
  end
end
