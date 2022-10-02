class AddEnabledToSource < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :enabled, :boolean, default: :true
  end
end
