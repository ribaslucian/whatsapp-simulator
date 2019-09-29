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

ActiveRecord::Schema.define(version: 2019_09_27_140227) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "acronyms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.string "name", limit: 64, null: false
    t.text "description"
    t.string "data_refer", limit: 64, null: false
    t.bigserial "ids", null: false
    t.index ["ids"], name: "rule_unique:acronyms.ids", unique: true
    t.index ["name"], name: "rule_unique:acronyms.name", unique: true
    t.index ["uuid"], name: "rule_unique:acronyms.uuid", unique: true
  end

  create_table "connections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "entity_id", null: false
    t.string "ipv4_private", limit: 24
    t.string "ipv4_public", limit: 24
    t.string "ipv6_public", limit: 32
    t.string "mac", limit: 24
    t.string "os", limit: 32
    t.string "browser", limit: 96
    t.datetime "date_logout"
    t.datetime "date_expiration", null: false
    t.bigserial "ids", null: false
    t.index ["entity_id"], name: "index_connections_on_entity_id"
    t.index ["ids"], name: "rule_unique:connections.ids", unique: true
  end

  create_table "contacts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "entity_id", null: false
    t.bigint "mean_acronym_id"
    t.bigint "category_acronym_id"
    t.string "description"
    t.string "value", limit: 96, null: false
    t.integer "priority", limit: 2, default: 1, null: false
    t.boolean "confirmed", default: false
    t.bigserial "ids", null: false
    t.index ["entity_id", "value"], name: "rule_unique:contacts.no_repeat_contact_for_entity", unique: true
    t.index ["entity_id"], name: "index_contacts_on_entity_id"
    t.index ["ids"], name: "rule_unique:contacts.ids", unique: true
  end

  create_table "contracts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "contractor_entity_id", null: false
    t.uuid "contracted_entity_id", null: false
    t.bigint "type_acronym_id", null: false
    t.boolean "active", default: true, null: false
    t.datetime "date_end"
    t.bigserial "ids", null: false
    t.index ["contractor_entity_id", "contracted_entity_id", "type_acronym_id"], name: "rule_unique:contracts.one_type_per_entities", unique: true
    t.index ["ids"], name: "rule_unique:contracts.ids", unique: true
  end

  create_table "entities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "gender_acronym_id"
    t.string "name", limit: 96, null: false
    t.boolean "legal", default: false, null: false
    t.bigserial "ids", null: false
    t.index ["ids"], name: "rule_unique:entities.ids", unique: true
  end

  create_table "identifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "entity_id", null: false
    t.bigint "type_acronym_id", null: false
    t.string "value", limit: 128, null: false
    t.string "printed_name", limit: 64
    t.datetime "validity"
    t.boolean "unique", default: true, null: false
    t.string "issuer", limit: 64
    t.datetime "issuer_date"
    t.bigserial "ids", null: false
    t.index ["entity_id", "value"], name: "rule_unique:identifications.one_identification_value_per_entity", unique: true
    t.index ["entity_id"], name: "index_identifications_on_entity_id"
    t.index ["ids"], name: "rule_unique:identifications.ids", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "entity_id", null: false
    t.boolean "blocked", default: false, null: false
    t.string "password_raw", limit: 32
    t.string "password_sha1", limit: 40
    t.string "password_md5", limit: 32
    t.uuid "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.bigserial "ids", null: false
    t.index ["entity_id"], name: "rule_unique:users.entity_id", unique: true
    t.index ["ids"], name: "rule_unique:users.ids", unique: true
    t.index ["reset_password_token"], name: "rule_unique:users.reset_password_token", unique: true
  end

  add_foreign_key "connections", "entities", name: "rule_fk:connections.entities"
  add_foreign_key "contacts", "entities", name: "rule_fk:contacts.entities"
  add_foreign_key "identifications", "entities", name: "rule_fk:identifications.entities"
  add_foreign_key "users", "entities", name: "rule_fk:users.entities"
end
