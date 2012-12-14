require "csv"

class UpdateDealAmounts < ActiveRecord::Migration
  def up
    remove_column :deals, :euro_rate
    remove_column :deals, :dollar_rate

    rename_column :deals, :amount, :amount_rub
    add_column :deals, :amount_usd, :integer
    add_column :deals, :amount_eur, :integer

    rates = {}
    CSV.foreach Rails.root.join("db/usd.csv"), col_sep: "\t" do |row|
      rates[Date.parse(row[0])] = row[1].to_f
    end

    default_rate = rates.values.reduce(:+) / rates.size

    Deal.find_each do |deal|
      next unless deal.amount_rub
      rate = (rates[deal.date] || default_rate)
      usd = deal.amount_rub / rate
      deal.update_column :amount_usd, usd.round
    end
  end

  def down
    add_column :deals, :euro_rate, :integer
    add_column :deals, :dollar_rate, :integer

    rename_column :deals, :amount_rub, :amount
    remove_column :deals, :amount_usd
    remove_column :deals, :amount_eur
  end
end
