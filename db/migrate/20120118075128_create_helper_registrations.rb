class CreateHelperRegistrations < ActiveRecord::Migration
  def self.up
    create_table :helper_registrations do |t|
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :helper_registrations
  end
end
