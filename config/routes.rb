Rails.application.routes.draw do
  resources :posts
  post '/callback' => 'linebot#callback'
  get '/post' => 'posts#index'
end
