class CreateS3Objects < ActiveRecord::Migration
  def change
    create_table :s3_objects do |t|
      t.string :bucket
      t.string :key
      t.string :url
      t.references :s3able ,:polymorphic => true

      t.timestamps
    end
  end
end
