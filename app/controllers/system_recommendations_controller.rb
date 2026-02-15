class SystemRecommendationsController < ApplicationController
  def index
    @recommendations = SystemRecommendation.all
  end

  def update
    @recommendation = SystemRecommendation.find(params.fetch(:id))
    if @recommendation.update(status: params[:status])
      redirect_back fallback_location: root_path, :notice => "Reccomendation updated."
    else
      redirect_back fallback_location: root_path, :alert => @recommendation.errors.full_messages.to_sentence
    end
  end
end
