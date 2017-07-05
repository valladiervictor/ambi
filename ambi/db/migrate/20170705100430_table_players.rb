class TablePlayers < ActiveRecord::Migration
  def change
    create_table :players
    add_column :players, :song_id, :integer
    add_column :players, :room_id, :integer
  end
end
