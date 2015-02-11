Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get '/survey/:link_code', :to => 'survey#show', :as => 'survey'
  post '/survey', :to => 'survey#create'

  devise_for :users

  get '/', :to => 'home#index', :as => 'home_index'

  root :to => "home#index"
end
