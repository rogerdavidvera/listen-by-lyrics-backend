class Api::V1::LyricsSearchEngineController < ApplicationController

  def search
    query = params["search_term"] # key in POST body must match
    results = LyricsSearchEngine.instance.search(query)
    render :json => results
  end

end
