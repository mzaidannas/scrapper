class AddEnabledToTag < ActiveRecord::Migration[7.0]
  def change
    add_column :tags, :enabled, :boolean, default: :true
  end
end
