class MembersController < ApplicationController
  layout "application_control"

  def index
    @labs = Lab.all
    @members = Member.all
  end

  def show
    @labs = Lab.all
    @member = Member.find(params[:id])
  end

end

