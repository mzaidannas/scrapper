# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_09_19_105356) do
  # These are extensions that must be enabled in order to support this database
  unless Rails.env.development?
    enable_extension "citus"
  end
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  unless Rails.env.development?
    create_enum "citus_copy_format", ["csv", "binary", "text"]
    create_enum "distribution_type", ["hash", "range", "append"]
    create_enum "noderole", ["primary", "secondary", "unavailable"]
    create_enum "shard_transfer_mode", ["auto", "force_logical", "block_writes"]
  end
  create_enum "job_statuses", ["pending", "success", "error", "warning"]
  create_enum "user_types", ["admin"]

  create_table "job_runs", primary_key: ["name", "created_at"], force: :cascade do |t|
    t.bigserial "id", null: false
    t.string "name", limit: 256, null: false
    t.enum "status", default: "pending", null: false, enum_type: "job_statuses"
    t.datetime "completed_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "error_message", limit: 256
    t.text "error_detail"
    t.index ["completed_at"], name: "index_job_runs_on_completed_at"
    t.index ["created_at"], name: "index_job_runs_on_created_at"
    t.index ["id"], name: "index_job_runs_on_id"
    t.index ["name"], name: "index_job_runs_on_name_gin", opclass: :gin_trgm_ops, using: :gin
    t.index ["name"], name: "index_job_runs_on_name_hash", using: :hash
  end

  create_table "news_sources", force: :cascade do |t|
    t.bigint "source_id"
    t.bigint "scraped_news_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scraped_news_id"], name: "index_news_sources_on_scraped_news_id"
    t.index ["source_id"], name: "index_news_sources_on_source_id"
  end

  create_table "news_tags", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "scraped_news_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["scraped_news_id"], name: "index_news_tags_on_scraped_news_id"
    t.index ["tag_id"], name: "index_news_tags_on_tag_id"
  end

  create_table "scraped_news", force: :cascade do |t|
    t.string "link"
    t.string "headline"
    t.text "description"
    t.string "slug"
    t.datetime "datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sources", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.text "description"
    t.string "slug"
    t.bigint "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_sources_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "slug"
    t.integer "level", default: 0
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["level"], name: "index_tags_on_level"
    t.index ["parent_id"], name: "index_tags_on_parent_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.enum "user_type", default: "admin", null: false, enum_type: "user_types"
    t.datetime "last_seen_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name_gin", opclass: :gin_trgm_ops, using: :gin
    t.index ["name"], name: "index_users_on_name_hash", using: :hash
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
