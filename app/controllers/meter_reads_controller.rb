class MeterReadsController < ApplicationController
  layout "application_no_header"
  #before_filter :authenticate_user!
  #load_and_authorize_resource

   
  def index
    @meter_reads = MeterRead.all
  end
   

   
  def show
    @meter_read = MeterRead.find(params[:id])

    @result = calculate(@meter_read)
  end
   

  def calculate(meter_read)
    total = meter_read.act_sm_read*meter_read.std_sm_wm + meter_read.act_big_read*meter_read.std_big_wm + meter_read.act_vst_read*meter_read.std_vst_wm + meter_read.act_smyc_read*meter_read.std_sm_yc + meter_read.act_bigyc_read*meter_read.std_big_yc

    act_mt_count = meter_read.act_sm_read + meter_read.act_big_read + meter_read.act_smyc_read + meter_read.act_bigyc_read
    mst_mt_count = meter_read.mst_sm_read + meter_read.mst_big_read + meter_read.mst_smyc_read + meter_read.mst_bigyc_read

    cj_rate = mst_mt_count == 0 ? 0 : act_mt_count.to_f/mst_mt_count.to_f*100
    acrt_rate = meter_read.smp_count == 0 ? 0 : meter_read.smp_fc_count.to_f/meter_read.smp_count.to_f*100
    rcy_rate = meter_read.wtr_count == 0 ? 0 : meter_read.rcv_count.to_f/meter_read.wtr_count.to_f*100

    acrt_mny = 0
    if cj_rate >= 98 && acrt_rate >= 98
      acrt_mny = 100
    else
      acrt_mny = -100
    end

    rcy_mny = 0
    rcy_rate_round = rcy_rate.round
    if 95 <= rcy_rate_round && rcy_rate_round < 98
      rcy_mny = 200 + (rcy_rate_round - 95)*200
    elsif 98 <= rcy_rate_round && rcy_rate_round <= 100 
      rcy_mny = 200 + 200*3 + 300 + (rcy_rate_round - 98)*300
    elsif 90 <= rcy_rate_round && rcy_rate_round < 95
      rcy_mny = (95 - rcy_rate_round)*(-50)
    elsif 80 <= rcy_rate_round && rcy_rate_round < 90
      rcy_mny = -250 + (90 - rcy_rate_round)*(-100)
    else
      rcy_mny = -1250 + (80 - rcy_rate_round)*(-200)
    end
    if rcy_mny < -2000
      rcy_mny = -2000
    end

    [total, act_mt_count, mst_mt_count, cj_rate, acrt_rate, rcy_rate, acrt_mny, rcy_mny]
    #total act_mt_count mst_mt_count cj_rate acrt_rate rcy_rate acrt_mny rcy_mny
  end

   
  def new
    @meter_read = MeterRead.new
    
  end
   

   
  def create
    @meter_read = MeterRead.new(meter_read_params)
    #@meter_read.user = current_user
    if @meter_read.save
      redirect_to @meter_read
    else
      render :new
    end
  end
   

   
  def edit
    @meter_read = MeterRead.find(params[:id])
  end
   

   
  def update
    @meter_read = MeterRead.find(params[:id])
    if @meter_read.update(meter_read_params)
      redirect_to meter_read_path(@meter_read) 
    else
      render :edit
    end
  end
   

   
  def destroy
    @meter_read = MeterRead.find(params[:id])
    @meter_read.destroy
    redirect_to :action => :index
  end
   

  

  

  private
    def meter_read_params
      params.require(:meter_read).permit( :std_sm_wm, :std_big_wm, :std_sm_yc, :std_big_yc, :std_vst_wm, :act_sm_read, :mst_sm_read, :act_big_read, :mst_big_read, :act_vst_read, :mst_vst_read, :act_smyc_read, :mst_smyc_read, :act_bigyc_read, :mst_bigyc_read, :rcv_count, :wtr_count, :name, :cal_date, :smp_fc_count, :smp_count)
    end
  
  
  
end

