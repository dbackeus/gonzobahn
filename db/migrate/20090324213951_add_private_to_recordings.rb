class AddPrivateToRecordings < ActiveRecord::Migration
  def self.up
    add_column :recordings, :private, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :recordings, :private
  end
end
