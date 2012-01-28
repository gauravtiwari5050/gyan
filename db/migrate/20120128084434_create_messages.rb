class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.string :unique_id
      t.string :subject
      t.text :content
      t.integer :from_user
      t.integer :to_user

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
