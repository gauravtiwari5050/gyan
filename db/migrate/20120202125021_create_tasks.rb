class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :type
      t.string :description
      t.string :completion_status
      t.string :execution_status
      t.text :output
      t.references :taskable,:polymorphic => true

      t.timestamps
    end
  end
end
