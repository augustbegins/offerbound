Rails.application.routes.draw do
  # Routes for the Touchpoint resource:
  resources :touchpoints

  #------------------------------

  # Routes for the Job application resource:
  resources :job_applications

  #------------------------------

  devise_for :users
 
  root to: "job_applications#index"
  
end
