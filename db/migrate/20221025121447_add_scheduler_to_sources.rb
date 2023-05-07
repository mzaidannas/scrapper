class AddSchedulerToSources < ActiveRecord::Migration[7.0]
  def change
    create_enum :schedules, %w[hourly daily weekly monthly yearly]
    add_column :sources, :schedule, :enum, enum_type: :schedules
  end
end
