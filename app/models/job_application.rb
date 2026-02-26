# == Schema Information
#
# Table name: job_applications
#
#  id                :bigint           not null, primary key
#  company_name      :string
#  due_date          :date
#  job_description   :text
#  job_title         :string
#  status            :integer
#  touchpoints_count :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :integer
#
class JobApplication < ApplicationRecord
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
  has_many :touchpoints, class_name: "Touchpoint", foreign_key: "job_application_id", dependent: :destroy
  has_many :system_recommendations, class_name: "SystemRecommendation", foreign_key: "job_application_id", dependent: :destroy
  enum :status, { planning: 0, applied: 1, interviewing: 2, offered: 3, rejected: 4 }
  validates :company_name, :job_title, :status, :due_date, :job_description, presence: true

  after_create_commit :generate_initial_recommendations

  private

  def generate_initial_recommendations
    Recommendations::JobApplicationOnCreateGenerator.call(self)
    wait_time = Rails.env.development? ? 5.seconds : 120.seconds
    JobApplicationFollowUpJob.set(wait: wait_time).perform_later(id)
  end
end
