class RemoveKeyFromScribdFile < ActiveRecord::Migration
  def up
    remove_column :scribd_files, :key
      end

  def down
    add_column :scribd_files, :key, :integer
  end
end
