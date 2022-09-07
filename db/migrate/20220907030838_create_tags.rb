class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.text :description
      t.string :slug, unique: true
      t.references :tag_group, index: true

      t.timestamps
    end
  end
end
