class AddStatusToEtherpad < ActiveRecord::Migration
  def self.up
    add_column :etherpads, :status, :string
  end

  def self.down
    remove_column :etherpads, :status
  end
end
