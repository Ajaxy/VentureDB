# encoding: utf-8

class MoveInternetScope < ActiveRecord::Migration
  def up
    internet = Scope.where(short_name: "ПО и интернет").first

    internet.move_to_root
    internet.update_column :short_name, "Интернет"
  end

  def down
    internet = Scope.where(short_name: "Интернет").first
    it       = Scope.where(short_name: "ИТ").first

    internet.move_to_child_of(it)
    internet.update_column :short_name, "ПО и интернет"
  end
end
