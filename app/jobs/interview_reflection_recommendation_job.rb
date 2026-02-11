class InterviewReflectionRecommendationJob < ApplicationJob
  queue_as :default

  def perform
    JobApplication.interviewing.find_each do |job_app|
      job_app.generate_interview_reflection_recommendations
    end
  end 
end
