Rails.application.routes.draw do
  get '/survey/:link_code', :to => 'survey#index', :as => 'survey_index'
  post '/survey/:link_code', :to => 'survey#create', :as => 'survey'

  devise_for :users

  get '/', :to => 'home#index', :as => 'home_index'

  root :to => "home#index"
end
