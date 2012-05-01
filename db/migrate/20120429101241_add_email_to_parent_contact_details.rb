class AddEmailToParentContactDetails < ActiveRecord::Migration
  def change
    add_column :parent_contact_details, :email, :string

  end
end
