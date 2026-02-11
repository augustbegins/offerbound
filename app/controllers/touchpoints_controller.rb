class TouchpointsController < ApplicationController
  before_action :set_job_applicaiton, only: [:index, :new, :create]
  before_action :set_touchpoint, only: [:show, :edit, :update, :destroy]

  def index
    @touchpoints = @job_application.touchpoints
    @job_applications = job_application_scope
    @job_applications = @job_applications.order(:created_at)
    job_application_ids = @job_applications.pluck(:id)
    current_index = job_application_ids.index(@job_application.id)
    @prev_job_app = current_index && current_index > 0 ? @job_applications[current_index - 1] : nil
    @next_job_app = current_index && current_index < job_application_ids.length - 1 ? @job_applications[current_index + 1] : nil
  end

  def show
    @touchpoints = @job_application.touchpoints.order(:occurred_at)
    touchpoint_ids = @touchpoints.pluck(:id)
    current_index = touchpoint_ids.index(@touchpoint.id)
    @prev_touchpoint = current_index && current_index > 0 ? @touchpoints[current_index - 1] : nil
    @next_touchpoint = current_index && current_index < touchpoint_ids.length - 1 ? @touchpoints[current_index + 1] : nil
  end

  def new
    @touchpoint = @job_application.touchpoints.build
    @form_model = [@job_application, @touchpoint]
  end

  def create
    @touchpoint = @job_application.touchpoints.build(touchpoint_params)

    if @touchpoint.valid?
      @touchpoint.save
      if @touchpoint.category == "interview"
        @job_application.update(status: :interviewing)
      end
      redirect_to job_application_touchpoints_url, :notice => "Touchpoint created successfully."
    else
      redirect_back fallback_location: root_path, :alert => @touchpoint.errors.full_messages.to_sentence
    end
  end

  def edit
    @form_model = @touchpoint
  end

  def update
    @touchpoint.assign_attributes(touchpoint_params)

    if @touchpoint.valid?
      @touchpoint.save
      redirect_to touchpoint_url(@touchpoint.id), :notice => "Touchpoint updated successfully."
    else
      redirect_back fallback_location: root_path, :alert => the_touchpoint.errors.full_messages.to_sentence
    end
  end

  def destroy
    @touchpoint.destroy

    redirect_to job_application_touchpoints_url, :notice => "Touchpoint deleted successfully."
  end

  private

  def set_job_applicaiton
    @job_application = job_application_scope.find(params.fetch(:job_application_id))
  end

  def set_touchpoint
    @touchpoint = find_scoped!(
      Touchpoint.within_job_applications(job_application_scope),
      id: params.fetch(:id),
    )
    @job_application = @touchpoint.job_application
  end

  def touchpoint_params
    params.require(:touchpoint).permit(:category, :notes, :occurred_at, :short_description)
  end
end
