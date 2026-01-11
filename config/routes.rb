Rails.application.routes.draw do
  resource :session
  resource :registration, only: %i[new create]
  resources :passwords, param: :token

  resources :habits do
    resources :completions, only: %i[create destroy]
    member do
      patch :archive
      patch :unarchive
    end
    collection do
      get :archived
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "habits#index"
end
