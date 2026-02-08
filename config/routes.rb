Rails.application.routes.draw do
  # Routes for the Job application resource:
  # Routes for the Touchpoint resource:
  # 
  resources :job_applications do
    resources :touchpoints, shallow: true
  end
  #------------------------------
  devise_for :users
  root to: "job_applications#index"
  
end
