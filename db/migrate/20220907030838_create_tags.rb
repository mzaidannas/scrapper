class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.text :description
      t.string :slug, unique: true
      t.integer :level, index: true, default: 0
      t.references :parent, index: true, optional: true

      t.timestamps
    end
  end
end
