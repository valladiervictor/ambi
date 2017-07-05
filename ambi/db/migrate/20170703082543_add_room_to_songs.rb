class AddRoomToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :room_id, :integer
    add_index :songs, :room_id
  end
end
