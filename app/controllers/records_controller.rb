class RecordsController < ApplicationController
  before_action :redirect_root, except: :index
  before_action :set_new_record, only: [:create, :back, :confirm, :complete] 
  before_action :set_today_record, only: [:create, :complete, :show] 
  before_action :set_id_record, only: [:edit, :update, :destroy ] 

  def index
    @records = Record.all
    @record = Record.new
    if user_signed_in?
      @record1 = Record.find_by(day_time: today , user_id: current_user.id)
    end
  end

  def create
    #今日のデータがなく、送られてきたデータに退勤があり、送られてきたデータに出勤時間がない時
    if @record1.nil? && @record.finish_time != nil && @record.begin_time.nil?
      render action: :confirm
    #今日のデータがない場合、送られてきたデータを保存する
    elsif @record1 == nil
      @record.save
      redirect_to root_path
    elsif @record1.finish_time != nil && @record.finish_time != nil
      render action: :confirm
    #現在のデータに出勤時間があり、退勤時間が送られてきた場合
    elsif @record1.begin_time != nil && @record.finish_time != nil
      @record1.update(record_params)
      redirect_to root_path
    else
      render action: :confirm
    end
  end

  def back
		redirect_to root_path
	end

	def confirm
		@record = Record.new
	end

	def complete
    #現在のデータがなく、送られてきたデータに出勤と退勤データがある場合かつ出勤時間が退勤時間が遅い時
    if @record1.nil? && @record.begin_time != nil && @record.finish_time != nil && check_time && check_break_time
       @record.save
       redirect_to record_path (current_user.id)
    #現在のデータがあり、出退勤データが送られてきた場合かつ、出勤時間が退勤時間が遅い時
		elsif @record != nil && @record.begin_time != nil && @record.finish_time != nil && check_time && check_break_time
      @record1.update(record_params)
      redirect_to record_path (current_user.id)
    else
      render :confirm
    end
	end

  def show
    @records = Record.where("day_time LIKE? AND user_id LIKE?", "%#{now_month}%", "%#{current_user.id}%").order('day_time')
  end

  def edit
  end

  def update
    @record1 = Record.find(params[:id])
    if @record1.update(record_params)
       redirect_to record_path(current_user.id)
    else 
      render :edit
    end
  end

  def destroy
    @record.destroy
    redirect_to record_path
  end

  def search
    @records = Record.search(keyword_params,id_params)
  end
  
  private

  def redirect_root
    redirect_to root_path unless user_signed_in?
  end

  def record_params
    params.require(:record).permit(:day_time, :begin_time, :finish_time, :break_time).merge(user_id: current_user.id)
  end

  def set_new_record
    @record = Record.new(record_params)
  end

  def set_id_record
    @record = Record.find(params[:id])

  end

  def set_today_record
    @record1 = Record.find_by(day_time:today , user_id:current_user.id)
  end

  def keyword_params
    params[:keyword]
  end
  def id_params
    params[:id]
  end
    
  def today
    time = Time.now
    year = time.year
    month = time.month
    day = time.day
    "#{year}-#{month}-#{day}"
  end

  def now_month
    time = Time.now
    year = time.year
    month = time.month
    day = time.day
    "#{year}-#{month}"
  end
end

def check_time
  @record.begin_time < @record.finish_time
end

def check_break_time
  (@record.finish_time - @record.begin_time)/3600 > @record.break_time
end

def check_day_time
    @record.user_id == current_user.id
end
