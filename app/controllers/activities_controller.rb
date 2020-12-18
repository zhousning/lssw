class ActivitiesController < ApplicationController
  layout "application_control"

  def index
    @activities = Activity.all.order("created_at DESC")
  end

  def show
    @activity = Activity.find(params[:id])
  end

  
end

