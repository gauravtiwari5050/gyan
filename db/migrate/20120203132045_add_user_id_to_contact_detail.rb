class AddUserIdToContactDetail < ActiveRecord::Migration
  def change
    add_column :contact_details, :user_id, :integer

  end
end
