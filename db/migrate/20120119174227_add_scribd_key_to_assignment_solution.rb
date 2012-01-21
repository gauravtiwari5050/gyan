class AddScribdKeyToAssignmentSolution < ActiveRecord::Migration
  def self.up
    add_column :assignment_solutions, :scribd_key, :string
  end

  def self.down
    remove_column :assignment_solutions, :scribd_key
  end
end
