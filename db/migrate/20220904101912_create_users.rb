class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    enable_extension :pg_trgm
    create_enum :user_types, %w[admin]
    create_table :users do |t|
      t.string :name
      t.enum :user_type, enum_type: 'user_types', default: 'admin', null: false
      t.datetime :last_seen_at

      t.timestamps

      t.index :name, using: :hash, name: :index_users_on_name_hash
      t.index :name, using: :gin, opclass: :gin_trgm_ops, name: :index_users_on_name_gin
    end
  end
end
