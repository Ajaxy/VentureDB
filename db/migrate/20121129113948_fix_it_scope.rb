# encoding: utf-8

class FixItScope < ActiveRecord::Migration
  def up
    scope = Scope.where(name: "Услуги в сфере ИКТ").first
    it    = Scope.where(short_name: "ИТ").first

    scope.move_to_child_of(it)
    it.update_column :short_name, "ИКТ"
  end

  def down
    scope = Scope.where(name: "Услуги в сфере ИКТ").first
    it    = Scope.where(short_name: "ИКТ").first

    scope.move_to_root
    it.update_column :short_name, "ИТ"
  end
end
