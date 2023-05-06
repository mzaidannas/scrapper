class AddOptionsToTags < ActiveRecord::Migration[7.0]
  def change
    add_column :tags, :whole_word, :boolean, default: :true
    add_column :tags, :case_sensitive, :boolean, default: :false
    add_column :tags, :starting, :boolean, default: :false
    add_column :tags, :ending, :boolean, default: :false
  end
end
