class LabsController < ApplicationController
  layout "application_control"

  def index
    @labs = Lab.all
  end

  def show
    @labs = Lab.all
    @lab = Lab.find(params[:id])
  end

end

