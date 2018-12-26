Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post '/search', action: :search, controller: 'lyrics_search_engine'
      get '/login', action: :login, controller: 'login'
      post '/spotifyusers', action: :create, controller: 'spotify_users'
    end
  end
end
