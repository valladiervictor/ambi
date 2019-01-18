class AddHistoryToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :past, :boolean
    add_column :songs, :liked, :boolean
  end
end
