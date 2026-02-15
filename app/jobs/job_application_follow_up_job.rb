class JobApplicationFollowUpJob < ApplicationJob
  queue_as :default

  def peform(job_application_id)
    job_application_id = JobApplication.find_by(id: job_application_id)
    return unless job_application
    return if job_application.rejected? || job_application.offered?
    Recommendations::JobApplicationFollowUpGenerator.call(job_application)
  end
end
