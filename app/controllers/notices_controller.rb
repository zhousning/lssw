class NoticesController < ApplicationController
  layout "application_control"

  def index
    @notices = Notice.all.order("created_at DESC")
  end

  def show
    @notice = Notice.find(params[:id])
  end

end

