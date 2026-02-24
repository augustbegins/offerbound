module Recommendations
  module Generators
    class InboundResponseCheck
      def self.call(touchpoint)
        new(touchpoint).call
      end

      def initialize(touchpoint)
        @touchpoint = touchpoint
      end

      def call
        return unless touchpoint.category == "inbound_email"
        touchpoint.job_application.system_recommendations.create!(
          recommendation_type: :follow_up,
          message: "Respond to the email you received.",
          status: :pending

        )
      end

      private

      attr_reader :touchpoint
    end
  end
end
