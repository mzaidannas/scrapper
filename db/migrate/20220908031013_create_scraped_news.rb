class CreateScrapedNews < ActiveRecord::Migration[7.0]
  def change
    create_table :scraped_news do |t|
      t.string :link
      t.string :headline
      t.text :description
      t.string :slug, unique: true
      t.datetime :datetime

      t.timestamps
    end
  end
end
