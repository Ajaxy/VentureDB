class AddContactsFieldsToPeople < ActiveRecord::Migration
  def change
    add_column :people, :address, :string
    add_column :people, :website, :string
    add_column :people, :facebook, :string
    add_column :people, :slideshare, :string
    add_column :people, :vkontakte, :string
    add_column :people, :vacancies, :string
    add_column :people, :mentions, :text
    add_column :people, :other_geo, :text
  end
end
