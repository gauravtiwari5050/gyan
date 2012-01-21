class CreateInstituteUrls < ActiveRecord::Migration
  def self.up
    create_table :institute_urls do |t|
      t.integer :institute_id
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :institute_urls
  end
end
