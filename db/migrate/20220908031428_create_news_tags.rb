class CreateNewsTags < ActiveRecord::Migration[7.0]
  def change
    create_table :news_tags do |t|
      t.references :tag, index: true
      t.references :scraped_news, index: true
      t.timestamps
    end
  end
end
