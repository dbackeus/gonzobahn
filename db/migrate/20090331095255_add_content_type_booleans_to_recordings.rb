class AddContentTypeBooleansToRecordings < ActiveRecord::Migration
  def self.up
    add_column :recordings, :has_audio, :boolean
    add_column :recordings, :has_video, :boolean
    
    Recording.update_all :has_audio => true, :has_video => true
  end

  def self.down
    remove_column :recordings, :has_video
    remove_column :recordings, :has_audio
  end
end
