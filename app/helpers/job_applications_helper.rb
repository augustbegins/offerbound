module JobApplicationsHelper
  def status_badge_class(status)
    case status.to_s.downcase
    when "applied"
      "badge-applied"
    when "interviewing"
      "badge-interview"
    when "offered"
      "badge-offer"
    when "rejected"
      "badge-rejected"
    when "planning"
      "badge-planning"
    end 
  end
end
