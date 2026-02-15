module Reccomendations
  class JobApplicationOnCreateGenerator
    def self.call(job_application)
      new(job_application).call
    end

    def initialize(job_application)
      @job_application = job_application
    end

    def call
      create_research_recommendation
      create_networking_recommendation
      create_resume_recommendation
    end

    private

    attr_reader :job_application

    def create_research_recommendation
      create_recommendation(
        type: :follow_up,
        message: "Research the company's mission, recent news, and team structure",
      )
    end

    def create_networking_recommendation
      create_recommendation(
        type: :follow_up,
        message: "Identify 2-3 employees to reach out to on LinkedIn.",
      )
    end

    def create_resume_recommendation
      create_recommendation(
        type: :follow_up,
        message: "Tailor your resume specifically for this job.",
      )
    end

    def create_recommendation(type:, message:)
      job_application.system_recommendations.create!(
        recommendation_type: type,
        message: message,
        status: :pending,
      )
    end
  end
end
