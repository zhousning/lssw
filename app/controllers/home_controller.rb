class HomeController < ApplicationController
  layout "application_control"

  def index
    @notices = Notice.limit(6).order("created_at DESC")
  end
end
