class CreateInstitutes < ActiveRecord::Migration
  def self.up
    create_table :institutes do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :institutes
  end
end
