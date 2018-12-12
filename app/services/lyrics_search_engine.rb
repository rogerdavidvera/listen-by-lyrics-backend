require 'google/apis/customsearch_v1'

class LyricsSearchEngine
  attr_accessor :search_engine

  def initialize()
    @search_engine = Google::Apis::CustomsearchV1.CustomsearchService.new
  end

end
