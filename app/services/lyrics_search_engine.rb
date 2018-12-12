require 'google/apis/customsearch_v1'

class LyricsSearchEngine
  attr_accessor :search_engine, :custom_search_engine_id

  def initialize()
    Dotenv.load('.env') # Load environment variables using Dotenv gem
    @search_engine = Google::Apis::CustomsearchV1::CustomsearchService.new
    @search_engine.key = ENV['API_KEY']
    @custom_search_engine_id = ENV['CUSTOM_SEARCH_ENGINE_ID']
  end

  def search(query)
    @search_engine.list_cse_siterestricts(query, {cx: @custom_search_engine_id})
  end

end
