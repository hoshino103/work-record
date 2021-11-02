class RecordsController < ApplicationController
  def index
    @records = Record.all
    @record = Record.new
    if user_signed_in?
      @record1 = Record.find_by(day_time: today , user_id: current_user.id)
    end
  end

  def create
    @record = Record.new(record_params)
    #ログインユーザーの今日の出退勤レコード
    @record1 = Record.find_by(day_time: today , user_id: current_user.id)
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
		@record = Record.new(record_params)
		redirect_to root_path
	end

	def confirm
		@record = Record.new
		@record = Record.new(record_params)
	end

	def complete
    @record1 = Record.find_by(day_time:today , user_id:current_user.id)
    @record = @record = Record.new(record_params)
    if @record1.nil? && @record.begin_time != nil && @record.finish_time != nil && @record.break_time !=nil && @record.valid?
       @record.save
       redirect_to record_path (current_user.id)
		elsif @record1.update(record_params) 
      redirect_to record_path (current_user.id)
    else
      @record = Record.new(record_params)
      render :confirm
    end
	end

  def show
    @records = Record.where("day_time LIKE? AND user_id LIKE?", "%#{now_month}%", "%#{current_user.id}%").order('day_time')
    @record1 = Record.find_by(day_time:today , user_id:current_user.id)
  end

  def edit
    @record = Record.find(params[:id])
  end

  def update
    @record1 = Record.find(params[:id])
    if @record1.update(record_params)
       redirect_to record_path(current_user.id)
    else 
      @record = Record.find(params[:id])
      render :edit
    end
  end

  def destroy
    @record = Record.find(params[:id])
    @record.destroy
    redirect_to record_path
  end

  def search
    @records = Record.search(keyword_params,id_params)
  end
  
  private

  def record_params
    params.require(:record).permit(:day_time, :begin_time, :finish_time, :break_time).merge(user_id: current_user.id)
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
