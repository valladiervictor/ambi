class AddThumbnailToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :thumbnail, :string
  end
end
