class Record < ApplicationRecord
  belongs_to :user

  validates :day_time, presence: true, format: { with: /\A\d{4}-\d{2}-\d{2}\z/ }
  validates :begin_time, presence: true, on: :complete, on: :update 
  validates :finish_time, presence: true, on: :complete,  on: :update
  validates :break_time, presence: true, on: :complete, on: :update

  validate :check_begin_time, on: :complete, on: :update
  validate :check_finish_time, on: :complete, on: :update
  validate :check_break_time , on: :complete, on: :update

  def check_begin_time 
      if begin_time != nil && finish_time != nil
        errors.add(:begin_time, "登録できません")if begin_time > finish_time
      end
  end
  def check_finish_time 
      if begin_time != nil && finish_time != nil
        errors.add(:finish_time, "登録できません")if begin_time > finish_time
      end
  end
  def check_break_time 
      if begin_time != nil && finish_time != nil
        work_time = (finish_time - begin_time) / 3600
        errors.add(:break_time, "登録できません")if  work_time.to_f < break_time.to_f
      end
  end
  
  def self.search(search,id)
    if search != ""
      Record.where('day_time LIKE(?) AND user_id LIKE(?)',"%#{search}%","%#{id}%").order('day_time')
    else
      Record.where('user_id LIKE(?)',"%#{id}%").order('day_time')
    end
  end
end
