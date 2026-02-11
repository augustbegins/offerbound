class SystemRecommendation < ApplicationRecord
  belongs_to :job_application, class_name: "JobApplication", foreign_key: "job_application_id"
  enum status: { pending: 0, dismissed: 1, acted_on: 2 }
  enum recommendation_type: { 
      follow_up: "follow up",
      thank_you_note: "thank you note", 
      deadline_warning: "deadline warning",
      post_interview_reflection: "post interview reflection"
  }
  validates :recommendation_type, :message, presence: true
end
