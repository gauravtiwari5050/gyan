class AddIndexToCourseCode < ActiveRecord::Migration
  def self.up
    add_index :courses, :code, :unique => true
  end

  def self.down
  end
end
