class SystemRecommendationsController < ApplicationController
  def index
    @recommendations = current_user_recommendations.order(created_at: :desc)
  end

  def update
    @recommendation = current_user_recommendations.find(params.fetch(:id))
    if @recommendation.update(status: params[:status])
      redirect_back fallback_location: system_recommendation_path, :notice => "Reccomendation updated."
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
