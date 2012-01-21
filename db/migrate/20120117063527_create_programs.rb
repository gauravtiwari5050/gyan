class CreatePrograms < ActiveRecord::Migration
  def self.up
    create_table :programs do |t|
      t.integer :department_id
      t.string :term_type
      t.integer :total_terms
      t.string :branch
      t.string :degree

      t.timestamps
    end
  end

  def self.down
    drop_table :programs
  end
end
