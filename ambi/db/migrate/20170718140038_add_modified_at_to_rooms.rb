class AddModifiedAtToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :modified_at, :datetime
    add_column :songs, :modified_at, :datetime
    add_column :players, :modified_at, :datetime
  end
end
