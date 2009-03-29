class AddViewsToRecordings < ActiveRecord::Migration
  def self.up
    add_column :recordings, :views, :integer, :default => 0
  end

  def self.down
    remove_column :recordings, :views
  end
end
