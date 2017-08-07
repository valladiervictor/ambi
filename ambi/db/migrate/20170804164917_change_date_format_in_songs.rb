class ChangeDateFormatInSongs < ActiveRecord::Migration
  def up
    change_column :songs, :modified_at, :integer
  end

  def down
    change_column :songs, :modified_at, :datetime
  end
end
