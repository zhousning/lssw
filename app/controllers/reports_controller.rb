class ReportsController < ApplicationController
  layout "application_control"

  def index
    @reports = Report.all.order("created_at DESC")
  end

  def show
    @report = Report.find(params[:id])
  end

  
end

