module Recommendations
  module Generators
    class InterviewReflection
      def self.call(touchpoint)
        new(touchpoint).call
      end

      def initialize(touchpoint)
        @touchpoint = touchpoint
      end

      def call
        return unless touchpoint.category == "interview"
        window = Time.zone.now.beginning_of_day - 24.hours..Time.zone.now.end_of_day + 24.hours
        return unless window.cover?(touchpoint.occurred_at)

        touchpoint.job_application.system_recommendations.create!(
          recommendation_type: :post_interview_reflection,
          message: "Take a few minutes to reflect after your interview today.",
          status: :pending
        )
      end

      private

      attr_reader :touchpoint

    end
  end
end
