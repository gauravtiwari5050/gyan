class CreateIvrsResults < ActiveRecord::Migration
  def change
    create_table :ivrs_results do |t|
      t.integer :ivrs_info_id
      t.integer :serial_number
      t.string :score

      t.timestamps
    end
  end
end
