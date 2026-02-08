Rails.application.routes.draw do
  # Routes for the Job application resource:
  resources :job_applications

  #------------------------------

  devise_for :users
 
  #root to: home#index
  
end
