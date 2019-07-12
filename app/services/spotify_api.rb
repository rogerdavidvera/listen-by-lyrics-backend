# require 'RSpotify'

class SpotifyAPI
  include Singleton

  attr_reader :search_engine, :custom_search_engine_id

  def initialize()
  end

  # Returns a hash to be rendered as JSON
  def search(artist, song)
    RSpotify.authenticate(ENV['SPOTIFY_CLIENT_ID'], ENV['SPOTIFY_CLIENT_SECRET'])
    result = RSpotify::Track.search("#{song} #{artist}", limit: 1, market: 'US').first
    if !!result
      format_result(result)
    else
      nil
    end
  end


  private

  def format_result(result)
    {
      :artists => get_artists_names(result.artists),
      :song => result.name,
      :track_id => result.id,
      :album => result.album.name,
      :album_art => result.album.images.first['url']
    }
  end

  def get_artists_names(artists)
    artists.map do |artist|
      artist.name
    end
  end


end
