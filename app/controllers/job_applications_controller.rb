class JobApplicationsController < ApplicationController
  before_action :set_job_applicaiton, only: [:show, :update, :destroy, :edit]

  def index
    @job_applications = job_application_scope
    @job_applications = @job_applications.order(:created_at)
  end
  
  def show
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
      render "job_applications/new"
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
      redirect_to job_applications_url(@job_application.id), :alert => the_job_application.errors.full_messages.to_sentence
    end
  end

  def destroy
    @job_application.destroy

    redirect_to job_applications_url(@job_application.id), :notice => "Job application deleted successfully."
  end

  private

  def set_job_applicaiton
    @job_application = job_application_scope.find(params.fetch(:id))
  end
  
  def job_application_params
    params.require(:job_application).permit(:company_name, :due_date, :job_description, :job_title, :status)
  end
end
