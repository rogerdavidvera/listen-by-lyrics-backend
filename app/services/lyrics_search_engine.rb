require 'google/apis/customsearch_v1'

class LyricsSearchEngine
  include Singleton

  attr_reader :search_engine, :custom_search_engine_id

  def initialize()
    # Load environment variables using Dotenv gem
    Dotenv.load('.env')
    # Instantiate single instance of API Client
    @search_engine = Google::Apis::CustomsearchV1::CustomsearchService.new
    # Assign API key
    @search_engine.key = ENV['API_KEY']
    # Set Custom Search Engine ID to single instance's attribute
    @custom_search_engine_id = ENV['CUSTOM_SEARCH_ENGINE_ID']
  end

  # Returns a hash to be rendered as JSON
  def search(query)
    # A search object returned from API call
    search_results = @search_engine.list_cse_siterestricts(query, {cx: @custom_search_engine_id})
    # Initialize format for results hash to be returned
    results = {:search_term => query, :songs => []}
    results[:songs] = format_search_results_from_API(search_results)
    return results
  end

  private

  # Returns a an array of formatted song hashes
  def format_search_results_from_API(search_results)
    if search_results.items == nil
      return [] # Nothing found
    end
    search_results.items.map do |result|
      if isSong?(result)
        format_search_result(result)
      end
    end.compact # Remove nil objects
  end

  # Returns a formatted song hash
  def format_search_result(result)
    if result.pagemap["breadcrumb"] == nil
      return nil
    end
    artists = result.pagemap["breadcrumb"][2]["title"]
    search_friendly_artists = format_artists_names(result.pagemap["breadcrumb"][2]["title"])
    song = parse_song_name_for_GENIUS(result.pagemap["breadcrumb"][3]["title"])
    spotify_result = SpotifyAPI.instance.search(search_friendly_artists, song)
    if spotify_result != nil
      {
        :track_id => spotify_result[:track_id],
        :song => spotify_result[:song],
        :artist => artists,
        :album => spotify_result[:album],
        :album_art => spotify_result[:album_art],
        :snippet => result.snippet,
        :lyrics_url => result.pagemap["metatags"][0]["og:url"],
        :lyrics => LyricsParser.instance.get_lyrics(result.pagemap["metatags"][0]["og:url"])
      }
    else
      nil
    end
  end

  # Returns true if result from GENIUS is a song link
  def isSong?(result)
    result.pagemap["metatags"][0]["og:type"] == "music.song"
  end

  def parse_song_name_for_GENIUS(raw_song_info)
    raw_song_info.split(" Lyrics").first
  end

  def format_artists_names(artists)
    split_names = artists.split(/&|,/)
    if split_names.size == 1
      split_names.join('')
    else
      without_whitespace = artists.split(/&|,/).map {|artist| artist.strip}
      formatted_string = without_whitespace.join(' ')
    end
  end

end
