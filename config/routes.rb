require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  mount ActionCable.server => "/cable"

  root "courses#index"

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: "users/confirmations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  get "up" => "rails/health#show", as: :rails_health_check
  get "responses/:user_id", to: "responses#index", as: :total_responses

  resources :messages, only: [ :index, :create ]

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
    resources :lessons do
      resources :responses, only: [ :create, :update, :show ]
    end
    resources :invitations, only: [ :new, :create ] do
      member do
        get :accept
      end
    end
    resources :topics do
      resources :lessons do
        resources :marks, only: [ :index, :create, :edit, :update ]
        collection do
          get "select_lesson_type"
        end
        resources :questions, only: [ :new, :create, :destroy ]
        post "submit_quiz_answers", to: "lessons#submit_quiz_answers", on: :member
      end
    end
  end
  resources :notifications, only: [ :index, :update ] do
    collection do
      get :unread_count
    end
  end
end
