class CreateSources < ActiveRecord::Migration[7.0]
  def change
    create_table :sources do |t|
      t.string :name
      t.string :url
      t.text :description
      t.string :slug, unique: true
      t.references :tag_group, index: true

      t.timestamps
    end
  end
end
