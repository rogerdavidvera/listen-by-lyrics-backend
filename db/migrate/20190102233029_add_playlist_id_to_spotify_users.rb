class AddPlaylistIdToSpotifyUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :spotify_users, :playlist_id, :string
  end
end
