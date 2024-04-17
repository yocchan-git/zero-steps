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

ActiveRecord::Schema[7.0].define(version: 2024_04_17_064055) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "complete_posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "complete_postable_type", null: false
    t.bigint "complete_postable_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["complete_postable_type", "complete_postable_id"], name: "index_complete_posts_on_complete_postable"
    t.index ["complete_postable_type", "complete_postable_id"], name: "index_complete_posts_on_postable", unique: true
    t.index ["user_id"], name: "index_complete_posts_on_user_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.bigint "follower_id", null: false
    t.bigint "followed_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_friendships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_friendships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_friendships_on_follower_id"
  end

  create_table "goals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "description"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "comment_id", null: false
    t.text "content"
    t.boolean "is_read", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id"], name: "index_notifications_on_comment_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "reactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "reactionable_type", null: false
    t.bigint "reactionable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reactionable_type", "reactionable_id"], name: "index_reactions_on_reactionable"
    t.index ["user_id", "reactionable_type", "reactionable_id"], name: "index_reactions_on_user_and_reactionable", unique: true
    t.index ["user_id"], name: "index_reactions_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "goal_id", null: false
    t.text "content"
    t.datetime "completion_limits", null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["goal_id"], name: "index_tasks_on_goal_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "timelines", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "timelineable_type", null: false
    t.bigint "timelineable_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["timelineable_type", "timelineable_id"], name: "index_timelines_on_timelineable"
    t.index ["user_id"], name: "index_timelines_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "uid", null: false
    t.string "name", null: false
    t.string "image"
    t.boolean "is_hidden", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "comments", "users"
  add_foreign_key "complete_posts", "users"
  add_foreign_key "friendships", "users", column: "followed_id"
  add_foreign_key "friendships", "users", column: "follower_id"
  add_foreign_key "goals", "users"
  add_foreign_key "notifications", "comments"
  add_foreign_key "notifications", "users"
  add_foreign_key "reactions", "users"
  add_foreign_key "tasks", "goals"
  add_foreign_key "tasks", "users"
  add_foreign_key "timelines", "users"
end
