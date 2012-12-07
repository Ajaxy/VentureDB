# encoding: utf-8

class PublishDeals < ActiveRecord::Migration
  def up
    Deal.find_each do |d|
      d.publish

      if d.errors.any?
        errors = (d.errors_log.to_s.split("\n") + d.errors[:publish]).compact.uniq
        errors.delete("Лог ошибок не пуст")
        errors.delete("")
        d.update_column :errors_log, errors.join("\n")
      end
    end
  end

  def down
  end
end
