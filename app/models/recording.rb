class Recording < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :filename
end
