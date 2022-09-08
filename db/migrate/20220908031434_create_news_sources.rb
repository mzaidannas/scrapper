class CreateNewsSources < ActiveRecord::Migration[7.0]
  def change
    create_table :news_sources do |t|
      t.references :source, index: true
      t.references :scraped_news, index: true
      t.timestamps
    end
  end
end
