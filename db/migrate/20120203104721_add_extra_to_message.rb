class AddExtraToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :email, :boolean
    add_column :messages, :sms, :boolean
    add_column :messages, :twitter, :boolean
    add_column :messages, :facebook, :boolean

  end
end
