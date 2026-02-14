class InterviewReflectionRecommendationJob < ApplicationJob
  queue_as :default

  def perform
    JobApplication.interviewing.find_each do |job_app|
      Recommendations::InterviewReflectionGenerator.call(job_app)
    end
  end 
end
