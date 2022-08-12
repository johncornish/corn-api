class Playlist < ApplicationRecord
  has_many :tracks
  accepts_nested_attributes_for :tracks
end
