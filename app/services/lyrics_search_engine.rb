require 'google/apis/customsearch_v1'

class LyricsSearchEngine
  attr_accessor :search_engine, :custom_search_engine_id

  def initialize(key, id)
    @search_engine = Google::Apis::CustomsearchV1::CustomsearchService.new
    @search_engine.key = key
    @custom_search_engine_id = id
  end

  def search(query)
    @search_engine.list_cses(query, {cx: @custom_search_engine_id})
  end

end
