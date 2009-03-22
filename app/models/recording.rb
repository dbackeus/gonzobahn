class Recording < ActiveRecord::Base
  acts_as_taggable
  
  validates_presence_of :title  
  validates_presence_of :filename
  validates_presence_of :user
  validates_presence_of :length
  
  belongs_to :user
  has_many :comments, :as => :commentable
  
  after_create :move_file_to_public_dir
  after_create :generate_thumbnail
  
  after_destroy :delete_files
  
  def directory
    "#{PUBLIC_RECORDINGS_DIR}/#{id}"
  end
  
  def file_path
    "#{directory}/#{filename}"
  end
  
  def thumbnail_path
    "/system/recordings/#{id}/image_original.jpg"
  end
  
  def length_pretty
    time = Time.at(length.round)
    sprintf("%02d:%02d", time.min, time.sec)
  end
  
  private
  def move_file_to_public_dir
    File.makedirs directory
    File.move "#{RED5_RECORDINGS_DIR}/#{filename}", file_path
  end
  
  # TODO: Post process to shrink or use something like Paperclip
  def generate_thumbnail
    `ffmpeg -i "#{file_path}" -an -ss 00:00:00 -vframes 1 -y "#{directory}/%d.jpg"`
    File.rename "#{directory}/1.jpg", "#{directory}/image_original.jpg"
  end
  
  def delete_files
    FileUtils.remove_dir directory
  end
end
