class CreateRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :records do |t|
      t.date :day_time
      t.time :begin_time
      t.time :finish_time
      t.integer :break_time
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
