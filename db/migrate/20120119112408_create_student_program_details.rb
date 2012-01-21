class CreateStudentProgramDetails < ActiveRecord::Migration
  def self.up
    create_table :student_program_details do |t|
      t.integer :student_id
      t.integer :program_id
      t.integer :term

      t.timestamps
    end
  end

  def self.down
    drop_table :student_program_details
  end
end
