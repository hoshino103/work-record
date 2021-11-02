module RecordsHelper

  def to_day
    time = Time.now
    year = time.year
    month = time.month
    day = time.day
    time.wday
    week =["日","月","火","水","木","金","土"]
    "#{year}年#{month}月#{day}日(#{week[time.wday]})"
  end

  def day_now
    time = Time.now
    year = time.year
    month = time.month
    day = time.day
    "#{year}-#{month}-#{day}"
  end


  def time_now
    time = Time.now
    hour = time.hour
    min = time.min.to_s
    sec = time.sec
    "#{hour}:#{min}:#{sec}"
  end

  def now_month
    time = Time.now
    year = time.year
    month = time.month
    day = time.day
    "#{year}-#{month}"
  end
end
