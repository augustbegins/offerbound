class CronController < ApplicationController
  def run
    Rails.logger.info "CRON TRIGGERED: #{params[:task]}"
    return head :unauthorized unless params[:token] == ENV["CRON_SECRET"]

    case params[:task]
    when "touchpoints"
      Touchpoint.all.each { |tp| Recommendations::TouchpointOnCreate.call(tp) }
    when "jobapps"
      JobApplication.all.each { |ja| Recommendations::Generators::JobApplicationFollowUp.call(ja) }
    end
    render plain: "OK"
  end
end
