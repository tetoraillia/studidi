Rails.application.routes.draw do
  root "courses#index"

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: "users/confirmations"
  }

  get "up" => "rails/health#show", as: :rails_health_check

  resources :courses do
    resources :enrollments, only: [:create, :destroy]
    resources :course_modules do
      resources :lessons
    end
  end
end