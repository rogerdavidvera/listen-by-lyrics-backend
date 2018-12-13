class Api::V1::LyricsSearchEngineController < ApplicationController

  def search
    query = params["search_term"] # key in POST body must match
    search_engine = LyricsSearchEngine.new()
    results = search_engine.search(query)
    #formattedResults = SearchResults.new(results)
    # query == results.queries["request"][0].search_terms
    byebug
  end

end
