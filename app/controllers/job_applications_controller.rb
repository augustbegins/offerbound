class JobApplicationsController < ApplicationController
  before_action :set_job_application, only: [:show, :update, :destroy, :edit]

  def index
    @job_applications = job_application_scope
    @job_applications = @job_applications.order(:created_at)
  end

  def show
    @job_applications = job_application_scope
    @job_applications = @job_applications.order(:created_at)
    job_application_ids = @job_applications.pluck(:id)
    current_index = job_application_ids.index(@job_application.id)
    @prev_job_app = current_index && current_index > 0 ? @job_applications[current_index - 1] : nil
    @next_job_app = current_index && current_index < job_application_ids.length - 1 ? @job_applications[current_index + 1] : nil
    @recommendations = @job_application.system_recommendations.pending
  end

  def new
    @job_application = current_user.job_applications.build
  end

  def create
    @job_application = current_user.job_applications.build(job_application_params)
    if @job_application.valid?
      @job_application.save
      redirect_to job_applications_url, :notice => "Job application created successfully."
    else
      redirect_to new_job_application_url, :alert => @job_application.errors.full_messages.to_sentence
    end
  end

  def edit
  end

  def update
    @job_application.assign_attributes(job_application_params)

    if @job_application.valid?
      @job_application.save
      redirect_to job_applications_url(@job_application.id), :notice => "Job application updated successfully."
    else
      redirect_to job_applications_url(@job_application.id), :alert => @job_application.errors.full_messages.to_sentence
    end
  end

  def destroy
    @job_application.destroy

    redirect_to job_applications_url(@job_application.id), :notice => "Job application deleted successfully."
  end

  after_create_commit :generate_initial_recommendations

  private

  def set_job_application
    @job_application = job_application_scope.find(params.fetch(:id))
  end

  def job_application_params
    params.require(:job_application).permit(:company_name, :due_date, :job_description, :job_title, :status)
  end

  def generate_initial_recommendations
    Recommendations::JobApplicationOnCreateGenerator.call(self)

    JobApplicationFollowUpJob.set(wait: 7.days).perform_later(id)
  end
end
