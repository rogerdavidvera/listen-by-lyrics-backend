class Api::V1::TracksController < ApplicationController
  def save
    track = Track.new(track_params)
    lyrics_url = params[:track][:lyrics_url]
    if track.valid?
      lyrics_hash = LyricsParser.instance.get_lyrics(lyrics_url)
      track.lyrics = lyrics_hash[:lyrics]
      track.save
    else
      # already exists
      track = Track.find_by(spotify_track_id: track.spotify_track_id)
    end
    # save to spotify playlist
    playlist_id = current_user.find_or_create_playlist
    track.add_to_playlist(playlist_id, current_user.access_token)
    render :json => {}
  end

  private
  def track_params
    params.require(:track).permit(:name, :artist, :album, :album_art, :spotify_track_id)
  end
end
