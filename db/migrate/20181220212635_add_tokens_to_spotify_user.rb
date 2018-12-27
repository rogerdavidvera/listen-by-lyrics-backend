class AddTokensToSpotifyUser < ActiveRecord::Migration[5.2]
  def change
    add_column :spotify_users, :access_token, :string
    add_column :spotify_users, :refresh_token, :string
  end
end
