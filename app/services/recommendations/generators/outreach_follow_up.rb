module Recommendations
  module Generators
    class OutreachFollowUp
      def self.call(touchpoint)
        new(touchpoint).call
      end

      def initialize(touchpoint)
        @touchpoint = touchpoint
      end

      def call
        return unless touchpoint.category == "outreach"
        touchpoint.job_application.system_recommendations.create!(
          recommendation_type: :follow_up,
          message: "Follow up on the outreach messages you've sent.",
          status: :pending

        )
      end

      private

      attr_reader :touchpoint
    end
  end
end
