class Recording < ActiveRecord::Base
  acts_as_taggable
  
  validates_presence_of :title  
  validates_presence_of :filename
  validates_presence_of :user
  
  belongs_to :user
  
  after_destroy :delete_file
  
  private
  def delete_file
    File.delete "#{STREAMS_DIR}/#{filename}.flv"
  end
end
