Rails.application.routes.draw do
  root "courses#index"
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: "users/confirmations"
  }
  get "up" => "rails/health#show", as: :rails_health_check

  resources :bookmarks, only: [ :index, :create, :destroy ]
  resources :courses do
    member do
      get :invite
    end
    resources :enrollments, only: [ :create, :destroy ] do
      member do
        delete :kick
      end
    end
    resources :invitations, only: [ :new, :create ] do
      member do
        get :accept
      end
    end
    resources :topics do
      resources :lessons do
        collection do
          get "select_lesson_type"
        end
      end
    end
  end
end
