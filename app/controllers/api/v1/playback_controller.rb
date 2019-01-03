require 'net/http'
require 'uri'
require 'json'

class Api::V1::PlaybackController < ApplicationController
  def play
    track_id = params[:track_uri]
    url = params[:lyrics_url]
    # current_user.refresh_access_token
    send_play_post_request(track_id)
    track = Track.find_by(spotify_track_id: track_id)
    if track
      render :json => {:lyrics => JSON.parse(track.lyrics)}
    else
      lyrics = LyricsParser.instance.get_lyrics(url)
      render :json => lyrics
    end
  end

  private

  def send_play_post_request(track_id)
    uri = URI.parse('https://api.spotify.com/v1/me/player/play')
    request = Net::HTTP::Put.new(uri)
    request.content_type = 'application/json'
    request["Accept"] = "application/json"
    # current_user.refresh_access_token
    request["Authorization"] = "Bearer #{current_user.access_token}"
    request.body = JSON.dump({"uris" => ["spotify:track:#{track_id}"]})
    req_options = {use_ssl: uri.scheme == "https"}
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end

end
