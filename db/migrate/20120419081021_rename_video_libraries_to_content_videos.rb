class RenameVideoLibrariesToContentVideos < ActiveRecord::Migration
  def up
    rename_table :video_libraries, :content_videos
  end

  def down
    rename_table  :content_videos,:video_libraries
  end
end
