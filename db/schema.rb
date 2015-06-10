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

ActiveRecord::Schema.define(version: 20150610172538) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "acessos", force: :cascade do |t|
    t.string "modulo"
    t.string "opcao"
    t.string "acao"
    t.string "descricao"
  end

  create_table "acessos_nivelacessos", force: :cascade do |t|
    t.integer "acesso_id"
    t.integer "nivelacesso_id"
  end

  create_table "empresas", force: :cascade do |t|
    t.string   "razao_social"
    t.string   "nome_fantasia"
    t.string   "cnpj"
    t.string   "insc_estadual"
    t.string   "insc_municipal"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "rua"
    t.string   "num_rua"
    t.string   "complemento"
    t.string   "bairro"
    t.string   "uf"
    t.string   "cep"
    t.integer  "adm_id",         default: 1
    t.string   "cidade"
  end

  create_table "empresas_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "empresa_id"
  end

  create_table "grupos", force: :cascade do |t|
    t.text     "descricao"
    t.integer  "adm_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nivelacessos", force: :cascade do |t|
    t.string   "descricao"
    t.integer  "adm_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.integer "user_id"
    t.string  "style"
    t.binary  "file_contents"
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",         null: false
    t.text     "value"
    t.integer  "target_id",   null: false
    t.string   "target_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["target_type", "target_id", "var"], name: "index_settings_on_target_type_and_target_id_and_var", unique: true, using: :btree

  create_table "subgrupos", force: :cascade do |t|
    t.text     "descricao"
    t.integer  "grupo_id"
    t.integer  "adm_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",       null: false
    t.string   "encrypted_password",     default: "",       null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fullname"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "user_type",              default: 2
    t.integer  "adm_id",                 default: 1
    t.string   "n_acesso",               default: "Padrão"
    t.integer  "nivelacesso_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
