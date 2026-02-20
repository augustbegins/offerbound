class SystemRecommendationsController < ApplicationController
  def index
    @recommendations = current_user_recommendations.order(created_at: :desc)
    @pending_recommendations_grouped = current_user_recommendations.where({ status: :pending })
                                                                  .includes(:job_application)
                                                                  .order("job_applications.company_name ASC")
                                                                  .group_by(&:job_application)
    @acted_on_recommendations_grouped = current_user_recommendations.where({ status: :acted_on })
                                                                  .includes(:job_application)
                                                                  .order("job_applications.company_name ASC")
                                                                  .group_by(&:job_application)
    @dismissed_recommendations_grouped = current_user_recommendations.where({ status: :dismissed })
                                                                  .includes(:job_application)
                                                                  .order("job_applications.company_name ASC")
                                                                  .group_by(&:job_application)
  end

  def update
    @recommendation = current_user_recommendations.find(params.fetch(:id))
    if @recommendation.update(status: params[:status])
      redirect_back fallback_location: system_recommendation_path, :notice => "Recommendation updated."
    else
      redirect_back fallback_location: root_path, :alert => @recommendation.errors.full_messages.to_sentence
    end
  end

  private
  
  def current_user_recommendations
    SystemRecommendation
      .joins(:job_application)
      .where(job_applications: { user_id: current_user.id})
  end
end
