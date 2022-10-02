class AddToIgnoreToTag < ActiveRecord::Migration[7.0]
  def change
    add_column :tags, :to_ignore, :boolean, default: :false
  end
end
