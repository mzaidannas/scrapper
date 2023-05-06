class CreateIgnoredLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :ignored_links do |t|
      t.string :link
      t.string :regex
      t.boolean :global, default: false
      t.text :description
      t.references :source, index: true

      t.timestamps
    end
  end
end
