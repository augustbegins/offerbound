class TouchpointsController < ApplicationController
  def index
    matching_touchpoints = Touchpoint.all

    @list_of_touchpoints = matching_touchpoints.order({ :created_at => :desc })

    render({ :template => "touchpoint_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_touchpoints = Touchpoint.where({ :id => the_id })

    @the_touchpoint = matching_touchpoints.at(0)

    render({ :template => "touchpoint_templates/show" })
  end

  def create
    the_touchpoint = Touchpoint.new
    the_touchpoint.job_application_id = params.fetch("query_job_application_id")
    the_touchpoint.occurred_at = params.fetch("query_occurred_at")
    the_touchpoint.category = params.fetch("query_category")
    the_touchpoint.notes = params.fetch("query_notes")
    the_touchpoint.short_description = params.fetch("query_short_description")

    if the_touchpoint.valid?
      the_touchpoint.save
      redirect_to("/touchpoints", { :notice => "Touchpoint created successfully." })
    else
      redirect_to("/touchpoints", { :alert => the_touchpoint.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_touchpoint = Touchpoint.where({ :id => the_id }).at(0)

    the_touchpoint.job_application_id = params.fetch("query_job_application_id")
    the_touchpoint.occurred_at = params.fetch("query_occurred_at")
    the_touchpoint.category = params.fetch("query_category")
    the_touchpoint.notes = params.fetch("query_notes")
    the_touchpoint.short_description = params.fetch("query_short_description")

    if the_touchpoint.valid?
      the_touchpoint.save
      redirect_to("/touchpoints/#{the_touchpoint.id}", { :notice => "Touchpoint updated successfully." } )
    else
      redirect_to("/touchpoints/#{the_touchpoint.id}", { :alert => the_touchpoint.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_touchpoint = Touchpoint.where({ :id => the_id }).at(0)

    the_touchpoint.destroy

    redirect_to("/touchpoints", { :notice => "Touchpoint deleted successfully." } )
  end
end
