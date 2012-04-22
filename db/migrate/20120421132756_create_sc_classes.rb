class CreateScClasses < ActiveRecord::Migration
  def change
    create_table :sc_classes do |t|
      t.string :name
      t.string :description
      t.integer :institute_id

      t.timestamps
    end
  end
end
