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

ActiveRecord::Schema.define(version: 20150828135541) do

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

  create_table "certificadodigitals", force: :cascade do |t|
    t.integer  "empresa_id"
    t.string   "cnpj"
    t.date     "inicio"
    t.date     "fim"
    t.binary   "imagem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "senha"
    t.string   "requerente"
  end

  create_table "cfops", force: :cascade do |t|
    t.string   "codigo"
    t.string   "descricao"
    t.boolean  "devolucao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "classificacaofiscals", force: :cascade do |t|
    t.string   "codigo_ncm"
    t.string   "descricao"
    t.integer  "adm_id"
    t.integer  "versao"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "codigo_ex"
    t.integer  "pis_cst_id"
    t.float    "pis_aliquota"
    t.integer  "cofins_cst_id"
    t.float    "cofins_aliquota"
    t.float    "ii_aliquota"
    t.integer  "ipi_cst_id"
    t.float    "ipi_aliquota"
  end

  create_table "cstpiscofins", force: :cascade do |t|
    t.integer  "codigo"
    t.string   "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "empresas_entidades", force: :cascade do |t|
    t.integer "empresa_id"
    t.integer "entidade_id"
  end

  create_table "empresas_grupos", force: :cascade do |t|
    t.integer "empresa_id"
    t.integer "grupo_id"
  end

  create_table "empresas_produtos", force: :cascade do |t|
    t.integer "empresa_id"
    t.integer "produto_id"
  end

  create_table "empresas_subgrupos", force: :cascade do |t|
    t.integer "empresa_id"
    t.integer "subgrupo_id"
  end

  create_table "empresas_unidades", force: :cascade do |t|
    t.integer "empresa_id"
    t.integer "unidade_id"
  end

  create_table "empresas_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "empresa_id"
  end

  create_table "enderecos", force: :cascade do |t|
    t.string   "rua"
    t.string   "num_rua"
    t.string   "complemento"
    t.string   "bairro"
    t.string   "uf"
    t.string   "cep"
    t.integer  "adm_id"
    t.string   "cidade"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "entidade_id"
    t.string   "tipo_endereco"
  end

  create_table "entidades", force: :cascade do |t|
    t.string   "razao_social"
    t.string   "nome_fantasia"
    t.string   "cnpj"
    t.string   "insc_estadual"
    t.string   "insc_municipal"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "adm_id"
    t.string   "telefone"
    t.string   "celular"
    t.string   "email"
  end

  create_table "entidades_tipoentidades", force: :cascade do |t|
    t.integer "entidade_id"
    t.integer "tipoentidade_id"
  end

  create_table "estados", force: :cascade do |t|
    t.integer  "codigo_ibge"
    t.string   "uf",           limit: 2
    t.string   "descricao",    limit: 50
    t.float    "icms_interno"
    t.float    "diferimento"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "grupos", force: :cascade do |t|
    t.text     "descricao"
    t.integer  "adm_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "icmsclassificacaofiscals", force: :cascade do |t|
    t.integer  "classificacaofiscal_id"
    t.integer  "estado_id"
    t.float    "reducaobasecalculo"
    t.float    "diferimento"
    t.float    "aliquota"
    t.boolean  "icmsst"
    t.integer  "modalidadebcicmsst_id"
    t.float    "mva"
    t.boolean  "reducaomva"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "icmscsts", force: :cascade do |t|
    t.string   "codigo"
    t.string   "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "icmsinterestaduals", force: :cascade do |t|
    t.integer  "origem"
    t.integer  "destino"
    t.float    "icms"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "icmsprodutos", force: :cascade do |t|
    t.integer  "produto_id"
    t.integer  "estado_id"
    t.float    "reducaobasecalculo"
    t.float    "diferimento"
    t.float    "aliquota"
    t.boolean  "icmsst"
    t.integer  "modalidadebcicmsst_id"
    t.float    "mva"
    t.boolean  "reducaomva"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "ipicsts", force: :cascade do |t|
    t.integer  "codigo"
    t.string   "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "modalidadebcicmssts", force: :cascade do |t|
    t.integer  "codigo"
    t.string   "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "movimentoms", force: :cascade do |t|
    t.date     "data"
    t.integer  "entidade_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "adm_id"
    t.text     "produtos_list"
    t.float    "totalquantidade"
    t.float    "totalvalor"
    t.boolean  "consumidor_final"
  end

  create_table "nivelacessos", force: :cascade do |t|
    t.string   "descricao"
    t.integer  "adm_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "origems", force: :cascade do |t|
    t.string   "codigo"
    t.string   "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "p_photos", force: :cascade do |t|
    t.integer "produto_id"
    t.string  "style"
    t.binary  "file_contents"
  end

  create_table "photos", force: :cascade do |t|
    t.integer "user_id"
    t.string  "style"
    t.binary  "file_contents"
  end

  create_table "piscofinscsts", force: :cascade do |t|
    t.integer  "codigo"
    t.string   "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "produtos", force: :cascade do |t|
    t.string   "descricao"
    t.string   "codigo"
    t.float    "preco"
    t.string   "unidade"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "adm_id"
    t.integer  "grupo_id"
    t.integer  "subgrupo_id"
    t.string   "p_photo_file_name"
    t.string   "p_photo_content_type"
    t.integer  "p_photo_file_size"
    t.datetime "p_photo_updated_at"
    t.boolean  "personalizado"
    t.integer  "classificacaofiscal_id"
    t.integer  "pis_cst_id"
    t.float    "pis_aliquota"
    t.integer  "cofins_cst_id"
    t.float    "cofins_aliquota"
    t.float    "ii_aliquota"
    t.integer  "ipi_cst_id"
    t.float    "ipi_aliquota"
    t.float    "frete",                  default: 0.0
    t.float    "desconto",               default: 0.0
    t.float    "seguro",                 default: 0.0
    t.float    "outros",                 default: 0.0
    t.integer  "origem_id"
  end

  create_table "series", force: :cascade do |t|
    t.integer  "serie"
    t.string   "modelo"
    t.integer  "ultima_nota_fiscal"
    t.string   "ambiente"
    t.integer  "empresa_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "adm_id"
  end

  add_index "series", ["empresa_id"], name: "index_series_on_empresa_id", using: :btree

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

  create_table "tipoentidades", force: :cascade do |t|
    t.string   "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "adm_id"
  end

  create_table "tipomovimentacaos", force: :cascade do |t|
    t.string   "descricao"
    t.string   "tipo"
    t.integer  "adm_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unidades", force: :cascade do |t|
    t.string   "abreviacao"
    t.string   "descricao"
    t.integer  "adm_id"
    t.boolean  "fracionado"
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
    t.string   "api_key"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "series", "empresas"
end
