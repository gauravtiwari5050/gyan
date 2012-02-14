class ChangeDateFormatInAssignments < ActiveRecord::Migration
  def up
    change_column :assignments, :deadline, :datetime
  end

  def down
    change_column :assignments, :deadline, :date
  end
end
