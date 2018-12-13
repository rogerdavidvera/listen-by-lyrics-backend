require 'google/apis/customsearch_v1'

class LyricsSearchEngine
  include Singleton

  attr_reader :search_engine, :custom_search_engine_id

  def initialize()
    Dotenv.load('.env') # Load environment variables using Dotenv gem
    @search_engine = Google::Apis::CustomsearchV1::CustomsearchService.new
    @search_engine.key = ENV['API_KEY']
    @custom_search_engine_id = ENV['CUSTOM_SEARCH_ENGINE_ID']
  end

  # Returns a searchObject
  def search(query)
    searchObject = @search_engine.list_cse_siterestricts(query, {cx: @custom_search_engine_id})
    searchObject.items.each do |result|
      if result.pagemap["metatags"][0]["og:type"] == "music.song"
        artist = result.pagemap["breadcrumb"][2]["title"]
        song = result.pagemap["breadcrumb"][3]["title"]
        albumArt = result.pagemap["metatags"][0]["og:image"]
        snippet = result.snippet
        puts artist
        puts song
        puts albumArt
        puts snippet
        puts "\n\n"
      end
    end
    return nil
  end

end
