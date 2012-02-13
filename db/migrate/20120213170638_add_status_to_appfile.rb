class AddStatusToAppfile < ActiveRecord::Migration
  def change
    add_column :appfiles, :status, :string

  end
end
