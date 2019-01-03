class Track < ApplicationRecord
  validates :spotify_track_id, uniqueness: true

  def add_to_playlist(playlist_id, access_token)
    getUrl = "https://api.spotify.com/v1/playlists/#{playlist_id}"
    getHeader = {
      Authorization: "Bearer #{access_token}"
    }
    response = RestClient.get(getUrl, getHeader)
    response_body = JSON.parse(response.body)
    playlist_tracks = response_body['tracks']['items']
    track_ids = playlist_tracks.map {|playlist_track| playlist_track['track']['id']}
    if track_ids.include? self.spotify_track_id
      return false
    else
      url = "https://api.spotify.com/v1/playlists/#{playlist_id}/tracks?"
      header = {
        Authorization: "Bearer #{access_token}",
        "Content-Type": 'application/json'
      }
      # PAYLOADS HAVE TO BE IN STRINGS
      payload = {"uris": ["spotify:track:#{self.spotify_track_id}"]}.to_json
      RestClient.post(url,payload,header)
      return true
    end
  end
end
