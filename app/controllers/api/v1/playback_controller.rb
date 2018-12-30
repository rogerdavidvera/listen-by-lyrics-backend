require 'net/http'
require 'uri'
require 'json'

class Api::V1::PlaybackController < ApplicationController
  def play
    track_id = params[:track_uri]
    url = params[:lyrics_url]
    # current_user.refresh_access_token
    send_play_post_request(track_id)
    lyrics = LyricsParser.instance.get_lyrics(url)
    render :json => lyrics
  end

  private

  def send_play_post_request(track_id)
    uri = URI.parse('https://api.spotify.com/v1/me/player/play')
    request = Net::HTTP::Put.new(uri)
    request.content_type = 'application/json'
    request["Accept"] = "application/json"
    request["Authorization"] = "Bearer #{current_user.access_token}"
    request.body = JSON.dump({"uris" => ["spotify:track:#{track_id}"]})
    req_options = {use_ssl: uri.scheme == "https"}
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
  end

end
