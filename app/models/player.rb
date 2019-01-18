class Player < ActiveRecord::Base
  belongs_to :rooms
  has_one :songs
end
