class RenameInterviewsCountToTouchpointsCountInJobApplications < ActiveRecord::Migration[8.0]
  def change
    rename_column :job_applications, :interviews_count, :touchpoints_count
  end
end
