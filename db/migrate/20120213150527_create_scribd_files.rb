class CreateScribdFiles < ActiveRecord::Migration
  def change
    create_table :scribd_files do |t|
      t.integer :appfile_id
      t.string :id
      t.integer :key

      t.timestamps
    end
  end
end
