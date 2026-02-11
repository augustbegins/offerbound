# == Schema Information
#
# Table name: system_recommendations
#
#  id                  :bigint           not null, primary key
#  message             :text
#  recommendation_type :string
#  status              :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  job_application_id  :integer
#
class SystemRecommendation < ApplicationRecord
  belongs_to :job_application, class_name: "JobApplication", foreign_key: "job_application_id"
  enum :status, { pending: 0, dismissed: 1, acted_on: 2 }
  enum :recommendation_type, { 
      follow_up: "follow up",
      thank_you_note: "thank you note", 
      deadline_warning: "deadline warning",
      post_interview_reflection: "post interview reflection"
  }
  validates :recommendation_type, :message, presence: true
end
