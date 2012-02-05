class CreateIvrsInfos < ActiveRecord::Migration
  def change
    create_table :ivrs_infos do |t|
      t.string :institute_id
      t.text :message

      t.timestamps
    end
  end
end
