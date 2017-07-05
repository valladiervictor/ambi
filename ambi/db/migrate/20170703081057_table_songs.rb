class TableSongs < ActiveRecord::Migration
  def change
    create_table :songs
    add_column :songs, :name, :string
    add_column :songs, :link, :string
    add_column :songs, :poll, :integer
  end
end
