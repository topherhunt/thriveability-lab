# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161002184918) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "like_flags", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "target_type"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "like_flags", ["target_type", "target_id"], name: "index_like_flags_on_target_type_and_target_id", using: :btree
  add_index "like_flags", ["user_id"], name: "index_like_flags_on_user_id", using: :btree

  create_table "omniauth_accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "omniauth_accounts", ["provider", "uid"], name: "index_omniauth_accounts_on_provider_and_uid", using: :btree
  add_index "omniauth_accounts", ["user_id"], name: "index_omniauth_accounts_on_user_id", using: :btree

  create_table "post_conversants", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.string   "intention_type"
    t.string   "intention_statement"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "post_conversants", ["post_id"], name: "index_post_conversants_on_post_id", using: :btree
  add_index "post_conversants", ["user_id"], name: "index_post_conversants_on_user_id", using: :btree

  create_table "post_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "post_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "post_anc_desc_idx", unique: true, using: :btree
  add_index "post_hierarchies", ["descendant_id"], name: "post_desc_idx", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "author_id"
    t.string   "title"
    t.text     "published_content"
    t.string   "intention_type"
    t.string   "intention_statement"
    t.boolean  "published",              default: false
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "reply_at_char_position"
    t.text     "draft_content"
    t.integer  "like_flags_count",       default: 0
  end

  add_index "posts", ["author_id"], name: "index_posts_on_author_id", using: :btree
  add_index "posts", ["parent_id"], name: "index_posts_on_parent_id", using: :btree

  create_table "predefined_tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "title"
    t.string   "subtitle"
    t.text     "introduction"
    t.string   "location"
    t.string   "quadrant_ul"
    t.string   "quadrant_ur"
    t.string   "quadrant_ll"
    t.string   "quadrant_lr"
    t.string   "call_to_action"
    t.string   "stage"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "like_flags_count",   default: 0
  end

  create_table "resources", force: :cascade do |t|
    t.integer  "creator_id"
    t.boolean  "ownership_affirmed"
    t.string   "title"
    t.text     "description"
    t.string   "url"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "target_type"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "like_flags_count",        default: 0
  end

  add_index "resources", ["target_type", "target_id"], name: "index_resources_on_target_type_and_target_id", using: :btree

  create_table "stay_informed_flags", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "target_type"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                                 default: "",   null: false
    t.string   "encrypted_password",                    default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "self_dreams",              limit: 1000
    t.string   "self_passions",            limit: 1000
    t.string   "self_skills",              limit: 1000
    t.string   "self_proud_traits",        limit: 1000
    t.string   "self_weaknesses",          limit: 1000
    t.string   "self_evolve",              limit: 1000
    t.string   "self_looking_for",         limit: 1000
    t.string   "self_work_at",             limit: 1000
    t.string   "self_professional_goals",  limit: 1000
    t.string   "self_fields_of_expertise", limit: 1000
    t.boolean  "has_set_password",                      default: true
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
