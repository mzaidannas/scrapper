class AddVisibleToScrapedNews < ActiveRecord::Migration[7.0]
  def change
    add_column :scraped_news, :visible, :boolean, default: :true
  end
end
