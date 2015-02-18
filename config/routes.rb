Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get '/survey/:link_code', :to => 'survey#show', :as => 'survey'
  post '/survey', :to => 'survey#create'
  get '/survey/:link_code/confirm_attendance', to: 'survey#confirm_attendance'
  get '/survey/:link_code/refuse_attendance', to: 'survey#refuse_attendance'

  devise_for :users

  get '/', :to => 'home#index', :as => 'home_index'

  root :to => "home#index"
end
