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

  def category_badge_class(category)
    case category.to_s.downcase
    when "reflection"
      "badge-applied"
    when "interview"
      "badge-interview"
    when "outreach"
      "badge-planning"
    when "inbound_email"
      "badge-rejected"
    when "other"
      "badge-offer"
    end
  end

end
