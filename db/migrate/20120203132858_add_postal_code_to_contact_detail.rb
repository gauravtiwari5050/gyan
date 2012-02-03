class AddPostalCodeToContactDetail < ActiveRecord::Migration
  def change
    add_column :contact_details, :postal_code, :string

  end
end
