Rails.application.routes.draw do
  # Routes for the Job application resource:
  # Routes for the Touchpoint resource:
  resources :job_applications, shallow: true do
    resources :touchpoints
  end
  # ------------------------------
  # Routes for the System recommendation resource:
  resources :system_recommendations, only: [:index, :update]
  #------------------------------
  devise_for :users
  root to: "pages#landing"
end
