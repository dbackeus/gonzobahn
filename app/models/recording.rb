class Recording < ActiveRecord::Base
  acts_as_taggable
  
  validates_presence_of :title  
  validates_presence_of :filename
  validates_presence_of :user
  
  belongs_to :user
  
  after_save :move_file_to_public_dir
  after_destroy :delete_file
  
  def file_path
    "#{PUBLIC_RECORDINGS_DIR}/#{id}/#{filename}.flv"
  end
  
  def recorded_file_path
    "#{RED5_RECORDINGS_DIR}/#{filename}.flv"
  end
  
  private
  def move_file_to_public_dir
    File.makedirs "#{PUBLIC_RECORDINGS_DIR}/#{id}"
    File.move recorded_file_path, file_path
  end
  
  def delete_file
    File.delete file_path
  rescue Errno::ENOENT => e
    logger.error e.message
  end
end
