Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :category, only: [:index, :create]
      resources :fixtures, only: [:index, :update]
      resources :top_words, only: [:index]
      resources :session, only: [:create, :index]
    end
  end

end
