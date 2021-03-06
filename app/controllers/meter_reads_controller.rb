require 'excel_tool'
require 'json'

class MeterReadsController < ApplicationController
  layout "application_no_header"
  #before_filter :authenticate_user!
  #load_and_authorize_resource
  

  def meter_xls_download
    send_file File.join(Rails.root, "public", "templates", "计件表.xlsx"), :filename => "计件表.xlsx", :type => "application/force-download", :x_sendfile=>true
  end
  

  def parse_excel
    excel = params["excel_file"]
    date = params["date"]
    tool = ExcelTool.new
    results = tool.parseExcel(excel.path)
    results["抄表数量统计"][3..-1].each do |items|
      params = Hash.new
      params[:cal_date] = date
      params[:std_big_wm ] = 10
      params[:std_sm_wm ] = 2
      params[:std_vst_wm ] = 3 
      params[:std_big_yc ] = 5
      params[:std_sm_yc ] = 1
      items.each do |k, v|
        if !(/A/ =~ k).nil?
          params[:name] = v.nil? ? 0 : v 
        elsif !(/B/ =~ k).nil?
          params[:act_big_read] = v.nil? ? 0 : v 
        elsif !(/C/ =~ k).nil?
          params[:mst_big_read] = v.nil? ? 0 : v 
        elsif !(/D/ =~ k).nil?
          params[:act_sm_read] = v.nil? ? 0 : v 
        elsif !(/E/ =~ k).nil?
          params[:mst_sm_read] = v.nil? ? 0 : v 
        elsif !(/F/ =~ k).nil?
          params[:act_vst_read] = v.nil? ? 0 : v 
        elsif !(/G/ =~ k).nil?
          params[:mst_vst_read] = v.nil? ? 0 : v 
        elsif !(/H/ =~ k).nil?
          params[:act_bigyc_read] = v.nil? ? 0 : v 
        elsif !(/I/ =~ k).nil?
          params[:mst_bigyc_read] = v.nil? ? 0 : v 
        elsif !(/J/ =~ k).nil?
          params[:act_smyc_read] = v.nil? ? 0 : v 
        elsif !(/K/ =~ k).nil?
          params[:mst_smyc_read] = v.nil? ? 0 : v 
        elsif !(/L/ =~ k).nil?
          params[:smp_fc_count] = v.nil? ? 0 : v 
        elsif !(/M/ =~ k).nil?
          params[:smp_count] = v.nil? ? 0 : v 
        elsif !(/O/ =~ k).nil?
          params[:rcv_count] = v.nil? ? 0 : v 
        elsif !(/P/ =~ k).nil?
          params[:wtr_count] = v.nil? ? 0 : v 
        end
      end
      MeterRead.create!(calculate_format(params))
    end
    redirect_to :action => :index
  end 

  def index
    @meter_reads = MeterRead.all
  end
   
  def show
    @meter_read = MeterRead.find(params[:id])
  end
   
  def new
    @meter_read = MeterRead.new
    
  end
   
  def create 
    @meter_read = MeterRead.new(calculate_format(meter_read_params))
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
    if @meter_read.update(calculate_format(meter_read_params))
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
  
    def calculate_format(input_params)
      output_params = input_params
      
      total = input_params[:act_sm_read].to_f*input_params[:std_sm_wm].to_f + input_params[:act_big_read].to_f*input_params[:std_big_wm].to_f + input_params[:act_vst_read].to_f*input_params[:std_vst_wm].to_f + input_params[:act_smyc_read].to_f*input_params[:std_sm_yc].to_f + input_params[:act_bigyc_read].to_f*input_params[:std_big_yc].to_f

      act_mt_count = input_params[:act_sm_read].to_f + input_params[:act_big_read].to_f + input_params[:act_smyc_read].to_f + input_params[:act_bigyc_read].to_f
      mst_mt_count = input_params[:mst_sm_read].to_f + input_params[:mst_big_read].to_f + input_params[:mst_smyc_read].to_f + input_params[:mst_bigyc_read].to_f

      cj_rate = mst_mt_count == 0 ? 0 : act_mt_count.to_f/mst_mt_count.to_f*100
      acrt_rate = input_params[:smp_count].to_f == 0 ? 0 : input_params[:smp_fc_count].to_f/input_params[:smp_count].to_f*100
      rcy_rate = input_params[:wtr_count].to_f == 0 ? 0 : input_params[:rcv_count].to_f/input_params[:wtr_count].to_f*100

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

      cj_rate = format("%0.2f", cj_rate).to_f
      acrt_rate = format("%0.2f", acrt_rate).to_f
      rcy_rate = format("%0.2f", rcy_rate).to_f

      output_params[:total] = total
      output_params[:act_mt_count] = act_mt_count
      output_params[:mst_mt_count] = mst_mt_count
      output_params[:cj_rate] = cj_rate
      output_params[:acrt_rate] = acrt_rate
      output_params[:rcy_rate] = rcy_rate
      output_params[:acrt_mny] = acrt_mny
      output_params[:rcy_mny] = rcy_mny

      output_params
    end
  
  
end

