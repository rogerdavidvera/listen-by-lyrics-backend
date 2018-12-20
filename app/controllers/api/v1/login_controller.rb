class Api::V1::LoginController < ApplicationController

  def login
    # User has clicked "login" button
    # Assemble GET request to Spotify to ask
    # User to authorize the application
    query_params = {
      client_id: ENV['SPOTIFY_CLIENT_ID'],
      response_type: "code",
      redirect_uri: ENV['REDIRECT_URI'],
      scope: 'streaming user-library-modify user-read-currently-playing playlist-modify-private user-modify-playback-state',
      show_dialog: true
    }
    url = "https://accounts.spotify.com/authorize/"

    redirect_to "#{url}?#{query_params.to_query}"
  end


end
