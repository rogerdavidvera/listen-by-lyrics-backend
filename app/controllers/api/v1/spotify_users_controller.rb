class Api::V1::SpotifyUsersController < ApplicationController

  def create
    # Handle response from Spotify
    if params[:error]
      redirect_to ENV['LISTEN_BY_LYRICS_HOME_URL']
    else
      # Assemble and send request to Spotify for access and refresh token
      body = {
        grant_type: "authorization_code",
        code: params[:code],
        redirect_uri: ENV['REDIRECT_URI'],
        client_id: ENV['SPOTIFY_CLIENT_ID'],
        client_secret: ENV['SPOTIFY_CLIENT_SECRET']
      }

      auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
      # convert response.body to json for assisgnment
      auth_params = JSON.parse(auth_response.body)
      # assemble and send request to Spotify for user profile information
      header = {
        Authorization: "Bearer #{auth_params["access_token"]}"
      }
      user_response = RestClient.get("https://api.spotify.com/v1/me", header)
      # convert response.body to json for assisgnment
      user_params = JSON.parse(user_response.body)

      # create new user based on response, or find the existing user in database
      @spotify_user = SpotifyUser.find_or_create_by(spotify_id: user_params['id'],
                      display_name: user_params['display_name'],
                      url: user_params['external_urls']['spotify'],
                      href: user_params['href'],
                      uri: user_params['uri'])
      img_url = user_params["images"][0] ? user_params["images"][0]["url"] : nil
      @spotify_user.update(profile_image: img_url)
      @spotify_user.update(access_token: auth_params["access_token"], refresh_token:  auth_params["refresh_token"])
    end
  end

end
