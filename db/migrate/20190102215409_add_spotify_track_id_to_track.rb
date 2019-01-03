class AddSpotifyTrackIdToTrack < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :spotify_track_id, :string
  end
end
