class Player < ActiveRecord::Base
  belongs_to :rooms
  has_one :songs
  validates :owner_id, uniqueness: { case_sensitive: false }
end
