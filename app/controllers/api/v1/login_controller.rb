class Api::V1::LoginController < ApplicationController

  skip_before_action :authorized, only: [:login]

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
    # redirects user's browser to Spotify's authorization page, which details
    # scopes my app is requesting
    redirect_to "#{url}?#{query_params.to_query}"
  end

  def show
    # If application_controller#authorized is successful,
    render json: {
      # Return JSON data for that current_user
      spotify_id: current_user.spotify_id,
      display_name: current_user.display_name,
      url: current_user.url,
      img_url: current_user.profile_image
      }
  end


end
