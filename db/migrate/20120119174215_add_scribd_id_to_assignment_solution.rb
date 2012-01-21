class AddScribdIdToAssignmentSolution < ActiveRecord::Migration
  def self.up
    add_column :assignment_solutions, :scribd_id, :string
  end

  def self.down
    remove_column :assignment_solutions, :scribd_id
  end
end
