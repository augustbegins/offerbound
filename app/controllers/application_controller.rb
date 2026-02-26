class ApplicationController < ActionController::Base
  include ScopedFinder
  
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  
  def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, :keys => [:username])
		
		devise_parameter_sanitizer.permit(:account_update, :keys => [:username])
  end

  def job_application_scope
    return JobApplication.all if current_user.admin?
    current_user.job_applications
  end
end
