class AddPlayerIdToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :player_id, :integer
    add_index :rooms, :player_id
  end
end
