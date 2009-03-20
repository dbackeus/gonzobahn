class AddLengthToRecordings < ActiveRecord::Migration
  def self.up
    add_column :recordings, :length, :float
  end

  def self.down
    remove_column :recordings, :length
  end
end
