class CreateEtherpads < ActiveRecord::Migration
  def self.up
    create_table :etherpads do |t|
      t.integer :course_group_id
      t.string :name
      t.string :server

      t.timestamps
    end
  end

  def self.down
    drop_table :etherpads
  end
end
