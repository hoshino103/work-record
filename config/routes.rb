Rails.application.routes.draw do
  devise_for :users
  get 'records', to: 'records#index'
end
