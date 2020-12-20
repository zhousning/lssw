class HomeController < ApplicationController
  layout "application_control"

  def index
    @notices = Notice.limit(10).order("created_at DESC")
    @cmpt_cstrs = Report.where(:category => Setting.reports.ctg_cstr).limit(10).order("created_at DESC")
    @cmpt_servs = Report.where(:category => Setting.reports.ctg_serv).limit(10).order("created_at DESC")
    @cmpt_knows = Report.where(:category => Setting.reports.ctg_know).limit(10).order("created_at DESC")

    @act_cmpts = Activity.where(:category => Setting.activities.ctg_cmpt).limit(10).order("created_at DESC")
    @act_orgs = Activity.where(:category => Setting.activities.ctg_org).limit(8).order("created_at DESC")
    @act_bases = Activity.where(:category => Setting.activities.ctg_base).limit(8).order("created_at DESC")
    @act_mebs = Activity.where(:category => Setting.activities.ctg_meb).limit(8).order("created_at DESC")

    @results = Result.all
  end
end
