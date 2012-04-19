class CreateVideoLibraries < ActiveRecord::Migration
  def change
    create_table :video_libraries do |t|
      t.string :branch
      t.string :course
      t.string :topic
      t.string :url
      t.string :credits

      t.timestamps
    end
  end
end
