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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121110102719) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "full_name"
    t.string   "place"
    t.string   "form"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "deals", :force => true do |t|
    t.integer  "project_id"
    t.boolean  "approx_date",                    :default => false
    t.date     "announcement_date"
    t.date     "contract_date"
    t.integer  "status_id"
    t.integer  "round_id"
    t.integer  "stage_id"
    t.boolean  "approx_amount",                  :default => false
    t.integer  "amount",            :limit => 8
    t.integer  "value_before",      :limit => 8
    t.integer  "value_after",       :limit => 8
    t.integer  "informer_id"
    t.string   "financial_advisor"
    t.string   "legal_advisor"
    t.text     "mentions"
    t.text     "comments"
    t.text     "errors_log"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "deals", ["informer_id"], :name => "index_deals_on_informer_id"
  add_index "deals", ["project_id"], :name => "index_deals_on_project_id"
  add_index "deals", ["round_id"], :name => "index_deals_on_round_id"
  add_index "deals", ["stage_id"], :name => "index_deals_on_stage_id"
  add_index "deals", ["status_id"], :name => "index_deals_on_status_id"

  create_table "investments", :force => true do |t|
    t.integer  "investor_id"
    t.integer  "deal_id"
    t.integer  "instrument_id"
    t.text     "share"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "investments", ["deal_id"], :name => "index_investments_on_deal_id"
  add_index "investments", ["instrument_id"], :name => "index_investments_on_instrument_id"
  add_index "investments", ["investor_id"], :name => "index_investments_on_investor_id"

  create_table "investors", :force => true do |t|
    t.integer  "actor_id"
    t.string   "actor_type"
    t.integer  "type_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "investors", ["actor_id", "actor_type"], :name => "index_investors_on_actor_id_and_actor_type"
  add_index "investors", ["type_id"], :name => "index_investors_on_type_id"

  create_table "location_bindings", :force => true do |t|
    t.integer  "entity_id"
    t.string   "entity_type"
    t.integer  "location_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "location_bindings", ["entity_id", "entity_type"], :name => "index_location_bindings_on_entity_id_and_entity_type"
  add_index "location_bindings", ["location_id"], :name => "index_location_bindings_on_location_id"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "full_name"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "locations", ["lft"], :name => "index_locations_on_lft"
  add_index "locations", ["parent_id"], :name => "index_locations_on_parent_id"
  add_index "locations", ["rgt"], :name => "index_locations_on_rgt"

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "project_authors", :force => true do |t|
    t.integer  "project_id"
    t.integer  "author_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "project_authors", ["author_id"], :name => "index_project_authors_on_author_id"
  add_index "project_authors", ["project_id"], :name => "index_project_authors_on_project_id"

  create_table "project_scopes", :force => true do |t|
    t.integer  "project_id"
    t.integer  "scope_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "project_scopes", ["project_id"], :name => "index_project_scopes_on_project_id"
  add_index "project_scopes", ["scope_id"], :name => "index_project_scopes_on_scope_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "company_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "projects", ["company_id"], :name => "index_projects_on_company_id"

  create_table "scopes", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "scopes", ["lft"], :name => "index_scopes_on_lft"
  add_index "scopes", ["parent_id"], :name => "index_scopes_on_parent_id"
  add_index "scopes", ["rgt"], :name => "index_scopes_on_rgt"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "person_id"
    t.integer  "company_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["company_id"], :name => "index_users_on_company_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["person_id"], :name => "index_users_on_person_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end