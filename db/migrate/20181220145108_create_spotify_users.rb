class CreateSpotifyUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :spotify_users do |t|
      t.string :spotify_id
      t.string :display_name
      t.string :url
      t.string :href
      t.string :uri
      t.string :profile_image

      t.timestamps
    end
  end
end
