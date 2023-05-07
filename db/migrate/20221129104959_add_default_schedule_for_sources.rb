class AddDefaultScheduleForSources < ActiveRecord::Migration[7.0]
  def change
    change_column_default :sources, :schedule, :hourly
  end
end
