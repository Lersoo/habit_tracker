Rails.application.routes.draw do
  resource :session
  resource :registration, only: %i[new create]
  resources :passwords, param: :token

  resources :habits do
    resources :completions, only: :create do
      collection do
        delete "/", to: "completions#destroy", as: ""
      end
    end
    member do
      patch :archive
      patch :unarchive
    end
    collection do
      get :archived
    end
  end

  get "statistics", to: "statistics#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  root "habits#index"
end
