class CreateSignups < ActiveRecord::Migration
  def self.up
    create_table :signups do |t|
      t.string :institute_name
      t.string :institute_url
      t.string :admin_email
      t.string :admin_pass
      t.string :admin_pass_confirm

      t.timestamps
    end
  end

  def self.down
    drop_table :signups
  end
end
