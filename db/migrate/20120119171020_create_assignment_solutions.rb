class CreateAssignmentSolutions < ActiveRecord::Migration
  def self.up
    create_table :assignment_solutions do |t|
      t.integer :assignment_id
      t.integer :user_id
      t.text :content
      t.string :file
      t.integer :marks

      t.timestamps
    end
  end

  def self.down
    drop_table :assignment_solutions
  end
end
