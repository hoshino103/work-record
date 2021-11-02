Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root to:  'records#index'
  resources :users, only: :show
  resources :records, only: [:index,:create,:show, :update, :edit, :destroy] do
    member do
      get 'search'
    end
    collection do
      post 'confirm'
      post 'back'
      post 'complete'
    end
  end
end
