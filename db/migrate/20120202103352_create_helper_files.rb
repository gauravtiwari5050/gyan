class CreateHelperFiles < ActiveRecord::Migration
  def change
    create_table :helper_files do |t|
      t.string :file

      t.timestamps
    end
  end
end
