class AddTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :type, :string, default: ""

    if user = User.find_by_email("ai@grow.bi")
      user.update_column :type, "admin"
    end
  end
end
