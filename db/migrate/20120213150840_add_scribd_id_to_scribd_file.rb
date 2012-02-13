class AddScribdIdToScribdFile < ActiveRecord::Migration
  def change
    add_column :scribd_files, :scribd_id, :string
  end
end
