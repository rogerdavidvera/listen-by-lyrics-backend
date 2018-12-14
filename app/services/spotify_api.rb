# require 'RSpotify'

class SpotifyAPI
  include Singleton

  attr_reader :search_engine, :custom_search_engine_id

  def initialize()
  end

  # Returns a hash to be rendered as JSON
  def search(song, artist)
    RSpotify.authenticate('07cd64b60fa94291aff5696e92c57042','217443dba7354c30b767905099a97ab8')
    track_results = RSpotify::Track.search("#{song} #{artist}")
    format_search_results(track_results).first
  end


  private

  def format_search_results(track_results)
    track_results.map do |result|
      format_result(result)
    end
  end

  def format_result(result)
    {
      :artists => get_artists_names(result.artists),
      :song => result.name,
      :track_id => result.id
    }
  end

  def get_artists_names(artists)
    artists.map do |artist|
      artist.name
    end
  end

  def artist_query_in_artists_array

  end

end
