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

ActiveRecord::Schema.define(version: 20181214090529) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string   "context_type", null: false
    t.integer  "context_id",   null: false
    t.integer  "author_id",    null: false
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["author_id"], name: "index_comments_on_author_id", using: :btree
  add_index "comments", ["context_type", "context_id"], name: "index_comments_on_context_type_and_context_id", using: :btree

  create_table "conversation_participant_joins", force: :cascade do |t|
    t.integer  "conversation_id", null: false
    t.integer  "participant_id",  null: false
    t.string   "intention",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conversation_participant_joins", ["conversation_id"], name: "index_conversation_participant_joins_on_conversation_id", using: :btree
  add_index "conversation_participant_joins", ["participant_id"], name: "index_conversation_participant_joins_on_participant_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.integer  "creator_id", null: false
    t.string   "title",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conversations", ["creator_id"], name: "index_conversations_on_creator_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.integer  "actor_id"
    t.string   "action"
    t.string   "target_type"
    t.integer  "target_id"
    t.datetime "created_at"
  end

  add_index "events", ["action"], name: "index_events_on_action", using: :btree
  add_index "events", ["actor_id"], name: "index_events_on_actor_id", using: :btree
  add_index "events", ["target_type", "target_id"], name: "index_events_on_target_type_and_target_id", using: :btree

  create_table "get_involved_flags", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "target_type"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "get_involved_flags", ["target_type", "target_id"], name: "index_get_involved_flags_on_target_type_and_target_id", using: :btree
  add_index "get_involved_flags", ["user_id"], name: "index_get_involved_flags_on_user_id", using: :btree

  create_table "like_flags", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "target_type"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "like_flags", ["target_type", "target_id"], name: "index_like_flags_on_target_type_and_target_id", using: :btree
  add_index "like_flags", ["user_id"], name: "index_like_flags_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "project_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sent_at"
  end

  add_index "messages", ["project_id"], name: "index_messages_on_project_id", using: :btree
  add_index "messages", ["recipient_id"], name: "index_messages_on_recipient_id", using: :btree
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "notify_user_id"
    t.boolean  "read",           default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
  end

  add_index "notifications", ["event_id"], name: "index_notifications_on_event_id", using: :btree
  add_index "notifications", ["notify_user_id"], name: "index_notifications_on_notify_user_id", using: :btree

  create_table "post_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id",   null: false
    t.integer "descendant_id", null: false
    t.integer "generations",   null: false
  end

  add_index "post_hierarchies", ["ancestor_id", "descendant_id", "generations"], name: "post_anc_desc_idx", unique: true, using: :btree
  add_index "post_hierarchies", ["descendant_id"], name: "post_desc_idx", using: :btree

  create_table "predefined_tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "title"
    t.string   "subtitle"
    t.string   "location_of_home"
    t.text     "help_needed"
    t.string   "stage"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "partners"
    t.string   "video_url"
    t.text     "desired_impact"
    t.text     "contribution_to_world"
    t.text     "location_of_impact"
    t.text     "q_background"
    t.text     "q_meaning"
    t.text     "q_community"
    t.text     "q_goals"
    t.text     "q_how_make_impact"
    t.text     "q_how_measure_impact"
    t.text     "q_potential_barriers"
    t.text     "q_project_assets"
    t.text     "q_larger_vision"
  end

  add_index "projects", ["owner_id"], name: "index_projects_on_owner_id", using: :btree

  create_table "resources", force: :cascade do |t|
    t.integer  "creator_id"
    t.boolean  "ownership_affirmed"
    t.string   "title"
    t.text     "description"
    t.string   "current_url"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "target_type"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source_name"
    t.integer  "viewings",                default: 0
    t.text     "relevant_to"
  end

  add_index "resources", ["creator_id"], name: "index_resources_on_creator_id", using: :btree
  add_index "resources", ["target_type", "target_id"], name: "index_resources_on_target_type_and_target_id", using: :btree
  add_index "resources", ["viewings"], name: "index_resources_on_viewings", using: :btree

  create_table "stay_informed_flags", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "target_type"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stay_informed_flags", ["target_type", "target_id"], name: "index_stay_informed_flags_on_target_type_and_target_id", using: :btree
  add_index "stay_informed_flags", ["user_id"], name: "index_stay_informed_flags_on_user_id", using: :btree

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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "bio_interior"
    t.text     "bio_exterior"
    t.text     "tagline"
    t.string   "location"
    t.string   "name",               null: false
    t.string   "auth0_uid",          null: false
    t.datetime "last_signed_in_at"
    t.string   "email"
    t.datetime "email_confirmed_at"
  end

  add_foreign_key "comments", "users", column: "author_id"
  add_foreign_key "conversation_participant_joins", "conversations"
  add_foreign_key "conversation_participant_joins", "users", column: "participant_id"
  add_foreign_key "conversations", "users", column: "creator_id"
  add_foreign_key "events", "users", column: "actor_id", on_delete: :cascade
  add_foreign_key "messages", "projects", on_delete: :nullify
  add_foreign_key "messages", "users", column: "recipient_id", on_delete: :cascade
  add_foreign_key "messages", "users", column: "sender_id", on_delete: :cascade
  add_foreign_key "notifications", "events", on_delete: :cascade
  add_foreign_key "notifications", "users", column: "notify_user_id", on_delete: :cascade
end
