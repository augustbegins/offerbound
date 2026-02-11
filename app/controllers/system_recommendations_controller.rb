class SystemRecommendationsController < ApplicationController
  def index
    @recommendations = SystemRecommendation.all
  end

  def update
    @recommendation = SystemRecommendation.find(params.fetch(:id))
    if @recommendation.valid?
      @recommendation.save
      redirect_to system_recommendation_path(@recommendation.id),  :notice => "Reccomendation updated."
    else
      redirect_back fallback_location: root_path, :alert => @recommendation.errors.full_messages.to_sentence
    end
  end
end
