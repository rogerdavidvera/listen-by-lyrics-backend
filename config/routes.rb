Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post '/search', action: :search, controller: 'lyrics_search_engine'
      post '/spotifyusers', action: :create, controller: 'spotify_users'
      get '/login', action: :login, controller: 'login'
      get '/auth', action: :show, controller: 'login'
      post '/play', action: :play, controller: 'playback'
    end
  end
end
