# == Schema Information
#
# Table name: touchpoints
#
#  id                 :bigint           not null, primary key
#  category           :integer
#  notes              :text
#  occurred_at        :date
#  short_description  :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  job_application_id :integer
#
class Touchpoint < ApplicationRecord
  belongs_to :application, required: true, class_name: "JobApplication", foreign_key: "job_application_id", counter_cache: :touchpoints_count
  enum :category, { inbound_email: 0, outreach: 1, interview: 2, reflection: 3, other: 4 }
  validates :category, :short_description, :notes, :occurred_at, presence: true 
end
