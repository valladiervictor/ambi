class TableRooms < ActiveRecord::Migration
  def change
    create_table :rooms
    add_column :rooms, :name, :string
  end
end
