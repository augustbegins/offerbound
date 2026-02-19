class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing]

  def landing
    if user_signed_in?
      redirect_to :job_applications
    else
      render :landing
    end
  end
end
