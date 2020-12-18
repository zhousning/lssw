class ManagesController < ApplicationController
  layout "application_control"

  def index
    @manages = Manage.all
  end

  def show
    @manage = Manage.find(params[:id])
  end

end

