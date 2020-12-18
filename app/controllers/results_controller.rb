class ResultsController < ApplicationController
  layout "application_control"

  def index
    @results = Result.all
  end

  def show
    @results = Result.all
    @result = Result.find(params[:id])
  end

end

