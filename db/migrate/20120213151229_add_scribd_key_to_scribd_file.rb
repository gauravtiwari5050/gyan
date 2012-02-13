class AddScribdKeyToScribdFile < ActiveRecord::Migration
  def change
    add_column :scribd_files, :scribd_key, :string

  end
end
