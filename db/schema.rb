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

ActiveRecord::Schema.define(version: 2019_01_22_131546) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.string "context_type", null: false
    t.integer "context_id", null: false
    t.integer "author_id", null: false
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_id"], name: "index_comments_on_author_id"
    t.index ["context_type", "context_id"], name: "index_comments_on_context_type_and_context_id"
  end

  create_table "conversation_participant_joins", id: :serial, force: :cascade do |t|
    t.integer "conversation_id", null: false
    t.integer "participant_id", null: false
    t.string "intention", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["conversation_id"], name: "index_conversation_participant_joins_on_conversation_id"
    t.index ["participant_id"], name: "index_conversation_participant_joins_on_participant_id"
  end

  create_table "conversations", id: :serial, force: :cascade do |t|
    t.integer "creator_id", null: false
    t.string "title", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["creator_id"], name: "index_conversations_on_creator_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.integer "actor_id"
    t.string "action"
    t.string "target_type"
    t.integer "target_id"
    t.datetime "created_at"
    t.index ["action"], name: "index_events_on_action"
    t.index ["actor_id"], name: "index_events_on_actor_id"
    t.index ["target_type", "target_id"], name: "index_events_on_target_type_and_target_id"
  end

  create_table "get_involved_flags", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "target_type"
    t.integer "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["target_type", "target_id"], name: "index_get_involved_flags_on_target_type_and_target_id"
    t.index ["user_id"], name: "index_get_involved_flags_on_user_id"
  end

  create_table "like_flags", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "target_type"
    t.integer "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["target_type", "target_id"], name: "index_like_flags_on_target_type_and_target_id"
    t.index ["user_id"], name: "index_like_flags_on_user_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.integer "sender_id"
    t.integer "recipient_id"
    t.integer "project_id"
    t.string "subject"
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "sent_at"
    t.index ["project_id"], name: "index_messages_on_project_id"
    t.index ["recipient_id"], name: "index_messages_on_recipient_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "notifications", id: :serial, force: :cascade do |t|
    t.integer "notify_user_id"
    t.boolean "read", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "event_id"
    t.index ["event_id"], name: "index_notifications_on_event_id"
    t.index ["notify_user_id"], name: "index_notifications_on_notify_user_id"
  end

  create_table "predefined_tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.integer "owner_id"
    t.string "title"
    t.string "subtitle"
    t.string "location_of_home"
    t.text "help_needed"
    t.string "stage"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "partners"
    t.string "video_url"
    t.text "desired_impact"
    t.text "contribution_to_world"
    t.text "location_of_impact"
    t.text "q_background"
    t.text "q_meaning"
    t.text "q_community"
    t.text "q_goals"
    t.text "q_how_make_impact"
    t.text "q_how_measure_impact"
    t.text "q_potential_barriers"
    t.text "q_project_assets"
    t.text "q_larger_vision"
    t.index ["owner_id"], name: "index_projects_on_owner_id"
  end

  create_table "resources", id: :serial, force: :cascade do |t|
    t.integer "creator_id"
    t.boolean "ownership_affirmed"
    t.string "title"
    t.text "description"
    t.string "current_url"
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string "target_type"
    t.integer "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "source_name"
    t.integer "viewings", default: 0
    t.text "relevant_to"
    t.index ["creator_id"], name: "index_resources_on_creator_id"
    t.index ["target_type", "target_id"], name: "index_resources_on_target_type_and_target_id"
    t.index ["viewings"], name: "index_resources_on_viewings"
  end

  create_table "stay_informed_flags", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "target_type"
    t.integer "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["target_type", "target_id"], name: "index_stay_informed_flags_on_target_type_and_target_id"
    t.index ["user_id"], name: "index_stay_informed_flags_on_user_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "tagger_id"
    t.string "tagger_type"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "user_profile_prompts", force: :cascade do |t|
    t.bigint "user_id"
    t.string "stem"
    t.text "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_profile_prompts_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.text "tagline"
    t.string "location"
    t.string "auth0_uid", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "last_signed_in_at"
    t.text "bio"
    t.string "website_url"
    t.index ["auth0_uid"], name: "index_users_on_auth0_uid", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
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
