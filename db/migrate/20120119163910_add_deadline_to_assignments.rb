class AddDeadlineToAssignments < ActiveRecord::Migration
  def self.up
    add_column :assignments, :deadline, :date
  end

  def self.down
    remove_column :assignments, :deadline
  end
end
