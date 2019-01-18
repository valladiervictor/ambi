class AddOwnerToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :owner, :string
  end
end
