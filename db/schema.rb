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

ActiveRecord::Schema[7.2].define(version: 2026_01_29_014027) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "anniversaries", force: :cascade do |t|
    t.bigint "pair_id", null: false
    t.string "title", null: false
    t.date "date", null: false
    t.integer "repeat_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pair_id"], name: "index_anniversaries_on_pair_id"
  end

  create_table "boards", force: :cascade do |t|
    t.bigint "pair_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pair_id"], name: "index_boards_on_pair_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "icon"
    t.string "hint_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "notifiable_type"
    t.bigint "notifiable_id"
    t.string "notification_kind", null: false
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"
    t.index ["notification_kind"], name: "index_notifications_on_notification_kind"
    t.index ["user_id", "read_at"], name: "index_notifications_on_user_id_and_read_at"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "pairs", force: :cascade do |t|
    t.bigint "user_id1", null: false
    t.bigint "user_id2", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.index ["user_id1", "user_id2"], name: "index_pairs_on_user_id1_and_user_id2", unique: true
    t.index ["user_id1"], name: "index_pairs_on_user_id1"
    t.index ["user_id2"], name: "index_pairs_on_user_id2"
  end

  create_table "post_memos", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "user_id", null: false
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_memos_on_post_id"
    t.index ["user_id"], name: "index_post_memos_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "pair_id"
    t.bigint "category_id", null: false
    t.string "title"
    t.datetime "reveal_at", null: false
    t.integer "sense_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_posts_on_category_id"
    t.index ["pair_id"], name: "index_posts_on_pair_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "presets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_presets_on_user_id"
  end

  create_table "rule_items", force: :cascade do |t|
    t.bigint "pair_id", null: false
    t.bigint "user_id", null: false
    t.string "category"
    t.string "title"
    t.text "memo"
    t.boolean "is_custom"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pair_id"], name: "index_rule_items_on_pair_id"
    t.index ["user_id"], name: "index_rule_items_on_user_id"
  end

  create_table "user_notification_settings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "notification_kind", null: false
    t.boolean "push_enabled", default: true, null: false
    t.string "frequency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "notification_kind"], name: "index_user_notification_settings_unique", unique: true
    t.index ["user_id"], name: "index_user_notification_settings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "icon"
    t.bigint "pair_id"
    t.string "my_code"
    t.string "partner_code"
    t.integer "sex"
    t.datetime "last_viewed_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["my_code"], name: "index_users_on_my_code", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "anniversaries", "pairs"
  add_foreign_key "boards", "pairs"
  add_foreign_key "notifications", "users"
  add_foreign_key "pairs", "users", column: "user_id1"
  add_foreign_key "pairs", "users", column: "user_id2"
  add_foreign_key "post_memos", "posts"
  add_foreign_key "post_memos", "users"
  add_foreign_key "posts", "categories"
  add_foreign_key "posts", "pairs"
  add_foreign_key "posts", "users"
  add_foreign_key "presets", "users"
  add_foreign_key "rule_items", "pairs"
  add_foreign_key "rule_items", "users"
  add_foreign_key "user_notification_settings", "users"
end
