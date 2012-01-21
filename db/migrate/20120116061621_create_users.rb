class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :institute_id
      t.string :username
      t.string :email
      t.string :password_crypt
      t.string :user_type
      t.string :one_time_login
      t.boolean :is_validated

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
