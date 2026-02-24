module Recommendations
  class TouchpointOnCreate
    def self.call(touchpoint)
      new(touchpoint).call
    end

    def initialize(touchpoint)
      @touchpoint = touchpoint
    end
    
    def call
      case @touchpoint.category
      when "outreach"
        enqueue_outreach_follow_up
      when "interview"
        enqueue_interview_reflection
      when "inbound_email"
        enqueue_inbound_check
      end
    end

    private 
    
    attr_reader :touchpoint

    def enqueue_outreach_follow_up
      TouchpointOutreachFollowUpJob.set(wait: 2.days).perform_later(touchpoint.id)
    end

    def enqueue_interview_reflection
      TouchpointInterviewReflectionJob.perform_now(touchpoint.id)
    end

    def enqueue_inbound_check
      TouchpointInboundResponseJob.set(wait: 1.day).perform_later(touchpoint.id)
    end

  end
end
