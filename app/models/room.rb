class Room < ActiveRecord::Base
  validates :name, uniqueness: { case_sensitive: false }, presence: true
  has_many :songs
  has_one :player
end
