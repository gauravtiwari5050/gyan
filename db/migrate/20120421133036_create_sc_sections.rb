class CreateScSections < ActiveRecord::Migration
  def change
    create_table :sc_sections do |t|
      t.string :name
      t.string :description
      t.integer :sc_class_id

      t.timestamps
    end
  end
end
