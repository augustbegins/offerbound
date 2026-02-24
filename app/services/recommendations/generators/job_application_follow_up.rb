module Recommendations
  module Generators
    class JobApplicationFollowUp
      def self.call(job_application)
        new(job_application).call
      end

      def initialize(job_application)
        @job_application = job_application
      end

      def call
        return if already_has_follow_up?
        create_follow_up_recommendation
      end

      private

      attr_reader :job_application

      def already_has_follow_up?
        job_application.system_recommendations.follow_up.pending.exists?
      end

      def create_follow_up_recommendation
        job_application.system_recommendations.create!(
          recommendation_type: :follow_up,
          message: "If you haven't heard back, consider sending a follow-up email.",
          status: :pending,
        )
      end
    end
  end
end
