class CreateHelperUserVerifies < ActiveRecord::Migration
  def self.up
    create_table :helper_user_verifies do |t|
      t.string :username
      t.string :pass
      t.string :pass_repeat

      t.timestamps
    end
  end

  def self.down
    drop_table :helper_user_verifies
  end
end
