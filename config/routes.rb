Rails.application.routes.draw do
  root to: "pages#landing"

  devise_for :users
  #------------------------------

  # Routes for the Job application resource:
  # Routes for the Touchpoint resource:
  resources :job_applications, shallow: true do
    resources :touchpoints
  end
  # ------------------------------
  # Routes for the System recommendation resource:
  resources :system_recommendations, only: [:index, :update]

  # Routes for System recommendation tabs
  get "system_recommendations/pending" => "system_recommendations#pending", as: :pending_recommendations
  get "system_recommendations/completed" => "system_recommendations#completed", as: :completed_recommendations
  get "system_recommendations/archived" => "system_recommendations#archived", as: :archived_recommendations

  # cron jobs
  namespace :cron do
    get :run
  end
end
