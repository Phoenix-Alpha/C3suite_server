# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_29_050358) do

  create_table "asset_kinds", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "description"
    t.string "alternates"
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "audios", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "play_count"
  end

  create_table "bookmarks", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "user_id"
    t.integer "content_id"
    t.string "content_type"
    t.bigint "content_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_bookmarks_on_content_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "build_tests", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "chapter_ids"
    t.string "content_type"
    t.string "no_of_items"
    t.bigint "content_id", null: false
    t.text "content_type_ids"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["content_id"], name: "index_build_tests_on_content_id"
    t.index ["user_id"], name: "index_build_tests_on_user_id"
  end

  create_table "bundle_assets", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "description"
    t.integer "kind"
    t.boolean "active"
    t.text "source_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bundle_id"
  end

  create_table "bundle_subscriptions", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "user_id"
    t.integer "bundle_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bundles", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "products"
    t.boolean "allow_single_product_subscription"
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "app_store_bundle_id"
    t.text "app"
    t.index ["slug"], name: "index_bundles_on_slug", unique: true
  end

  create_table "content_assets", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "kind"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "content_id", null: false
    t.boolean "active", default: false
    t.integer "contents_id"
    t.text "source_data"
    t.index ["contents_id"], name: "index_content_assets_on_contents_id"
  end

  create_table "contents", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "product_id"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ancestry"
    t.string "actable_type"
    t.integer "actable_id"
    t.string "title"
    t.integer "view_count"
    t.integer "time"
    t.integer "row_order"
    t.text "description"
    t.index ["actable_type", "actable_id"], name: "index_contents_on_actable_type_and_actable_id"
    t.index ["ancestry"], name: "index_contents_on_ancestry"
    t.index ["product_id"], name: "fk_rails_6f4dae6b48"
  end

  create_table "delayed_jobs", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", size: :long, null: false
    t.text "last_error", size: :long
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
    t.index ["queue"], name: "delayed_jobs_queue"
  end

  create_table "features", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.string "state"
    t.string "roles"
    t.integer "percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "flashcard_items", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.text "front"
    t.text "back"
    t.integer "flashcard_id"
    t.integer "row_order"
    t.string "side_data"
    t.index ["flashcard_id"], name: "index_flashcard_items_on_flashcard_id"
  end

  create_table "flashcards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci", force: :cascade do |t|
    t.boolean "shuffle"
    t.text "sides_label", size: :medium
    t.string "attachment_side"
    t.string "sides_count", default: "2"
    t.boolean "inherit_modulee_configs", default: true
  end

  create_table "friendly_id_slugs", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, length: { slug: 70, scope: 70 }
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", length: { slug: 140 }
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "htmls", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.boolean "has_plain_text"
    t.text "html_source"
  end

  create_table "incorrect_questions", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "content_id"
    t.integer "content_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_id"], name: "index_incorrect_questions_on_content_id"
    t.index ["user_id"], name: "index_incorrect_questions_on_user_id"
  end

  create_table "media", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "local_type"
    t.string "caption"
    t.text "transcript"
    t.integer "duration"
    t.string "thumbnail_url"
    t.text "source_data"
  end

  create_table "modulees", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "time_limit"
    t.string "section_title"
    t.text "configurations"
  end

  create_table "permissions", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.integer "user_id"
    t.integer "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role_id"
    t.text "contents"
    t.index ["product_id"], name: "index_permissions_on_product_id"
    t.index ["role_id"], name: "index_permissions_on_role_id"
    t.index ["user_id", "product_id"], name: "index_permissions_on_user_id_and_product_id", unique: true
    t.index ["user_id"], name: "index_permissions_on_user_id"
  end

  create_table "product_assets", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_id", null: false
    t.integer "kind"
    t.boolean "active", default: false
    t.text "source_data"
    t.index ["product_id"], name: "index_product_assets_on_product_id"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "title"
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "visibility"
    t.string "tagline"
    t.text "html_description"
    t.string "pricing_model"
    t.integer "frequency"
    t.decimal "price", precision: 10, scale: 2
    t.string "slug"
    t.text "tags"
    t.text "configurations"
    t.string "background_data"
    t.string "app_store_bundle_id"
    t.text "app"
    t.text "stripe"
    t.index ["slug"], name: "index_products_on_slug", unique: true
  end

  create_table "questions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci", force: :cascade do |t|
    t.text "hint", size: :medium
    t.text "explanation", size: :medium
    t.integer "quiz_id"
    t.text "question", size: :medium
    t.text "correct", size: :medium
    t.text "distractor1", size: :medium
    t.text "distractor2", size: :medium
    t.text "distractor3", size: :medium
    t.text "distractor4", size: :medium
    t.text "distractor5", size: :medium
    t.text "distractor6", size: :medium
    t.text "distractor7", size: :medium
    t.text "distractor8", size: :medium
    t.text "distractor9", size: :medium
    t.string "category"
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
  end

  create_table "quizzes", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "q_type"
    t.integer "time_limit"
    t.boolean "shuffle"
    t.boolean "back_navigation"
    t.boolean "start_over"
    t.integer "passing_percentage"
    t.boolean "skippable"
    t.boolean "inherit_modulee_configs", default: true
  end

  create_table "roles", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.text "session_id", null: false
    t.text "data", size: :long
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, length: 255
  end

  create_table "submodules", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "name"
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "user_roles", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "role_id"
    t.index ["role_id"], name: "fk_rails_3369e0d5fc"
    t.index ["user_id"], name: "fk_rails_318345354e"
  end

  create_table "user_subscriptions", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "product_id", null: false
    t.date "sub_start"
    t.date "sub_end"
    t.text "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "transaction_id"
    t.index ["product_id", "user_id"], name: "index_user_subscriptions_on_product_id_and_user_id"
    t.index ["product_id"], name: "index_user_subscriptions_on_product_id"
    t.index ["user_id"], name: "index_user_subscriptions_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "ancestry"
    t.string "stripe_customer_id"
    t.index ["ancestry"], name: "index_users_on_ancestry"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "item_type", limit: 191, null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "videos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "url"
    t.integer "play_count"
  end

  create_table "viewed_contents", options: "ENGINE=InnoDB DEFAULT CHARSET=latin1", force: :cascade do |t|
    t.string "content_type"
    t.string "ancestry"
    t.text "content_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "content_id"
    t.boolean "completed", default: false
    t.integer "remaining_time"
    t.index ["ancestry"], name: "index_viewed_contents_on_ancestry"
    t.index ["content_id"], name: "index_viewed_contents_on_content_id"
    t.index ["user_id"], name: "index_viewed_contents_on_user_id"
  end

  add_foreign_key "build_tests", "contents"
  add_foreign_key "build_tests", "users"
  add_foreign_key "incorrect_questions", "contents"
  add_foreign_key "incorrect_questions", "users"
  add_foreign_key "viewed_contents", "contents"
  add_foreign_key "viewed_contents", "users"
end
