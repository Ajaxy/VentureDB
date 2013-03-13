class AddColumnsToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :prev_name, :string
    add_column :companies, :mentions, :string

    add_column :companies, :address1, :string
    add_column :companies, :phone1, :string
    add_column :companies, :www1, :string
    add_column :companies, :facebook1, :string
    add_column :companies, :vkontakte1, :string
    add_column :companies, :vacancies1, :string

    add_column :companies, :address2, :string
    add_column :companies, :phone2, :string
    add_column :companies, :www2, :string
    add_column :companies, :facebook2, :string
    add_column :companies, :vkontakte2, :string
    add_column :companies, :vacancies2, :string

    add_column :companies, :details, :text
    add_column :companies, :secret_details, :text
    add_column :companies, :sectors, :string

    add_column :people, :sex, :string
    add_column :people, :education, :string
    add_column :people, :age, :string
    add_column :people, :country, :string
    add_column :people, :sectors, :string
  end
end
