class AddIndex < ActiveRecord::Migration
  def self.up
    add_index :institutes, :code, :unique => true
    add_index :institute_urls, :url, :unique => true
  end

  def self.down
  end
end
