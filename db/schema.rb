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

ActiveRecord::Schema.define(version: 20151009041725) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clinics", force: true do |t|
    t.integer  "practice_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "practice_group_id"
  end

  create_table "distribution_clinics", force: true do |t|
    t.integer  "distribution_id"
    t.integer  "practice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "distribution_contacts", force: true do |t|
    t.integer  "distribution_id"
    t.integer  "fyi_contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "distribution_practice_groups", force: true do |t|
    t.integer  "distribution_id"
    t.integer  "practice_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "distributions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fyi_contacts", force: true do |t|
    t.string   "email",      null: false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fyi_contacts", ["email"], name: "email_primary", unique: true, using: :btree

  create_table "logs", force: true do |t|
    t.string   "type"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patients", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "practice_id"
    t.string   "practice_name"
    t.date     "visitDate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "run"
    t.integer  "fid"
    t.integer  "run_id"
  end

  create_table "patients_new", force: true do |t|
    t.string  "name"
    t.string  "email"
    t.integer "practice_id"
    t.date    "visitDate"
  end

  create_table "practice_groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "practice_code"
  end

  create_table "practice_reports", force: true do |t|
    t.integer  "practice_id"
    t.integer  "practice_group_id"
    t.integer  "run_id"
    t.float    "n1"
    t.float    "n2"
    t.float    "n3"
    t.float    "a1"
    t.float    "a2"
    t.float    "a3"
    t.float    "a4"
    t.float    "a5"
    t.float    "a6"
    t.float    "a7"
    t.float    "a8"
    t.float    "response_rate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stat_type"
    t.integer  "responses"
  end

  create_table "runs", force: true do |t|
    t.string   "name"
    t.string   "month"
    t.string   "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "start_date"
    t.string   "end_date"
    t.string   "quarter"
    t.string   "fiscal_year"
    t.string   "month_name"
  end

  create_table "survey_answers", force: true do |t|
    t.integer  "patient_id"
    t.string   "status"
    t.integer  "fid"
    t.string   "created"
    t.string   "ip"
    t.string   "location"
    t.string   "nps"
    t.string   "run"
    t.string   "collector"
    t.integer  "a1"
    t.text     "c1"
    t.integer  "a2"
    t.string   "b2"
    t.integer  "a3"
    t.text     "c3"
    t.integer  "a4"
    t.text     "c4"
    t.integer  "a5"
    t.text     "c5"
    t.integer  "a6"
    t.text     "c6"
    t.integer  "a7"
    t.text     "c7"
    t.integer  "a8"
    t.text     "c8"
    t.integer  "n1"
    t.integer  "n2"
    t.integer  "n3"
    t.text     "c9"
    t.integer  "practice_id"
    t.integer  "run_id"
    t.string   "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "a3o"
    t.text     "a4o"
    t.text     "a5o"
    t.text     "a6o"
    t.text     "a7o"
    t.text     "a8o"
    t.text     "n1o"
    t.text     "n2o"
  end

  create_table "survey_results", force: true do |t|
    t.integer  "patient_id"
    t.string   "status"
    t.integer  "fid"
    t.string   "created"
    t.string   "ip"
    t.string   "location"
    t.integer  "nps"
    t.string   "run"
    t.string   "collector"
    t.integer  "a1"
    t.integer  "a2"
    t.integer  "a3"
    t.integer  "a4"
    t.integer  "a5"
    t.text     "a6comment"
    t.text     "posfeedback"
    t.integer  "b1"
    t.integer  "b2"
    t.integer  "b3"
    t.integer  "b4"
    t.integer  "b5"
    t.text     "b6comment"
    t.boolean  "contact"
    t.text     "negfeedback"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "duration"
    t.integer  "practice_id"
    t.integer  "run_id"
  end

  create_table "surveys", force: true do |t|
    t.string   "run"
    t.integer  "count"
    t.string   "month"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temp_email", id: false, force: true do |t|
    t.text "email"
  end

  create_table "winners", force: true do |t|
    t.integer  "run_id"
    t.integer  "patient_id"
    t.integer  "practice_id"
    t.string   "name"
    t.string   "witness"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
