class AddOwnerToPlayer < ActiveRecord::Migration
  def change
    add_column :rooms, :owner_id, :integer
  end
end
