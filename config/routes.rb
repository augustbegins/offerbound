Rails.application.routes.draw do
  # Routes for the Job application resource:
  # Routes for the Touchpoint resource:
  # Routes for the System recommendation resource:
  # ------------------------------ 
  resources :job_applications, shallow: true do
    resources :touchpoints
    resources :system_recommendation, only: [:index, :update]
  end
  #------------------------------
  devise_for :users
  root to: "job_applications#index"
  
end
