class Api::V1::SpotifyUsersController < ApplicationController

  def create
    # handle response from Spotify
    if params[:error]
      redirect_to ENV['LISTEN_BY_LYRICS_HOME_URL']
    end
  end

end
