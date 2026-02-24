class TouchpointOutreachFollowUpJob < ApplicationJob
  queue_as :default

  def perform(touchpoint_id)
    touchpoint = Touchpoint.find_by(id: touchpoint_id)
    return unless touchpoint

    Recommendations::Generators::OutreachFollowUp.call(touchpoint)
  end
  
end
