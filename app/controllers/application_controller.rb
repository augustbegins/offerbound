class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def job_application_scope
    return JobApplication.all if current_user.admin?
    current_user.job_applications
  end
end
