class Api::V1::LyricsSearchEngineController < ApplicationController
  skip_before_action :authorized

  def search
    query = params["search_term"] # key in POST body must match
    results = LyricsSearchEngine.instance.search(query)
    render :json => results
  end

end
