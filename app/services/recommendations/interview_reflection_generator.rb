module Reccomendations
  class InterviewReflectionGenerator
    def self.call(job_application)
      new(job_application).call
    end

    def initialize
      @job_application = job_application
    end
    
    def call
      return unless job_application.interviewing?
      return unless interviews_today?

      create_recommendation
    end

    private 

    attr_reader :job_application
    def interviews_today?
      job_application.touchpoints.interview.where(occured_at: Date.today.all_day).exists?
    end

    def create_recommendation
      job_application.system_recommendations.create!(
        recommendation_type: :post_interview_reflection,
        message: "Record a reflection after your interview today.",
        status: :pending 
      )
    end
  end
end
