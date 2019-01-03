class CreateTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :tracks do |t|
      t.string :name
      t.string :artist
      t.string :album
      t.string :album_art
      t.string :lyrics
      t.integer :spotify_user_id

      t.timestamps
    end
  end
end
