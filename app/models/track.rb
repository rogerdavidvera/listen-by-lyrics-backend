class Track < ApplicationRecord
  belongs_to :spotify_user
  validates :spotify_track_id, uniqueness: { scope: :spotify_user,
  message: "should happen once per year" }
end
