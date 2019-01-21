class Api::V1::SpotifyUsersController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def create
    # Handle response from Spotify
    if params[:error]
      redirect_to ENV['LISTEN_BY_LYRICS_HOME_URL']
    else
      # Assemble body and POST request to Spotify for access and refresh token
      body = {
        grant_type: "authorization_code",
        code: params[:code], # Unique code is obtained from frontend
        redirect_uri: ENV['REDIRECT_URI'],
        client_id: ENV['SPOTIFY_CLIENT_ID'],
        client_secret: ENV['SPOTIFY_CLIENT_SECRET']
      }
      auth_response = RestClient.post('https://accounts.spotify.com/api/token', body)
      # Convert response.body to JSON for assisgnment
      auth_params = JSON.parse(auth_response.body)
      # Assemble header and send request to Spotify for user profile information
      header = {
        Authorization: "Bearer #{auth_params["access_token"]}"
      }
      # The reponse is the user information data
      user_response = RestClient.get("https://api.spotify.com/v1/me", header)
      # convert response.body to JSON for assisgnment
      user_params = JSON.parse(user_response.body)
      # Create new user based on JSON response data,
      # OR find the existing user in database
      @spotify_user = SpotifyUser.find_or_create_by(
        spotify_id: user_params['id'],
        url: user_params['external_urls']['spotify'],
        href: user_params['href'],
        uri: user_params['uri']
      )
      # Display name is not a unique identifier, so set one if there
      display_name = user_params['display_name']
      # Set img_url if one is there, otherwise set as nil
      img_url = user_params["images"][0] ? user_params["images"][0]["url"] : nil
      # Add or update user's display name and profile image:
      @spotify_user.update(profile_image: img_url, display_name: display_name)
      # Update the access and refresh tokens in the database
      @spotify_user.update(
        access_token: auth_params["access_token"],
        refresh_token:  auth_params["refresh_token"]
      )
      # Create payload containing user's unique spotify ID
      payload = {user_id: @spotify_user.id}
      # Issue a JWT token containing encoded user ID
      token = issue_token(payload)
      # Send JSON data to front end
      render json: {
        jwt: token, # Used to save to local storage, as it is securely encoded
        # User information can be sent to update application state
        user: {
          spotify_id: @spotify_user.spotify_id,
          display_name: @spotify_user.display_name,
          url: @spotify_user.url,
          img_url: @spotify_user.profile_image
        }
      }
    end
  end

end
