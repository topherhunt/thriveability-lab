class RemovePostsAndConversants < ActiveRecord::Migration
  def up
    drop_table :post_conversants
    drop_table :posts
  end

  def down
    create_table "posts", force: :cascade do |t|
      t.integer  "author_id"
      t.string   "title"
      t.text     "published_content"
      t.boolean  "published",              default: false
      t.datetime "published_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "parent_id"
      t.integer  "reply_at_char_position"
      t.text     "draft_content"
    end

    add_index "posts", ["author_id"], name: "index_posts_on_author_id"
    add_index "posts", ["parent_id"], name: "index_posts_on_parent_id"

    create_table "post_conversants", force: :cascade do |t|
      t.integer  "user_id"
      t.integer  "post_id"
      t.string   "intention"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "post_conversants", ["post_id"], name: "index_post_conversants_on_post_id"
    add_index "post_conversants", ["user_id"], name: "index_post_conversants_on_user_id"
  end
end
