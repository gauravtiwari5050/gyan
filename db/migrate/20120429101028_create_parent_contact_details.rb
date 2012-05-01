class CreateParentContactDetails < ActiveRecord::Migration
  def change
    create_table :parent_contact_details do |t|
      t.string :name
      t.string :phone
      t.integer :user_id

      t.timestamps
    end
  end
end
