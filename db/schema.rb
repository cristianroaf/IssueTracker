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

ActiveRecord::Schema.define(version: 2019_11_14_185648) do

  create_table "comments", force: :cascade do |t|
    t.string "text"
    t.integer "user_id", null: false
    t.integer "issue_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["issue_id"], name: "index_comments_on_issue_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "issues", force: :cascade do |t|
    t.string "Title"
    t.string "Description"
    t.string "Type"
    t.string "Priority"
    t.string "Status"
    t.string "user_id"
    t.string "asignee_id"
    t.integer "Votes"
    t.integer "Watchers"
    t.string "at_name"
    t.string "at_format"
    t.integer "at_size"
    t.datetime "at_updated_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "votes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "issue_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["issue_id"], name: "index_votes_on_issue_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  create_table "watchers", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "issue_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["issue_id"], name: "index_watchers_on_issue_id"
    t.index ["user_id"], name: "index_watchers_on_user_id"
  end

  add_foreign_key "comments", "issues"
  add_foreign_key "comments", "users"
  add_foreign_key "votes", "issues"
  add_foreign_key "votes", "users"
  add_foreign_key "watchers", "issues"
  add_foreign_key "watchers", "users"
end
