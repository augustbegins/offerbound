# == Schema Information
#
# Table name: job_applications
#
#  id               :bigint           not null, primary key
#  company_name     :string
#  due_date         :date
#  interviews_count :integer
#  job_description  :text
#  job_title        :string
#  status           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#
class JobApplication < ApplicationRecord
  belongs_to :user
  enum :status, { planning: 0, applied: 1, interviewing: 2, offered: 3, rejected: 4 }
  validates :company_name, :job_title, :status, presence: true
end
