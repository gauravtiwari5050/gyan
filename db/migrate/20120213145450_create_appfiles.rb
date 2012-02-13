class CreateAppfiles < ActiveRecord::Migration
  def change
    create_table :appfiles do |t|
      t.string :name
      t.string :content
      t.references :appfileable ,:polymorphic => true
      t.timestamps
    end
  end
end
