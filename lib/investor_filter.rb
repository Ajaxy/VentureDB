# encoding: utf-8

class InvestorFilter < Filter
  def filter(investors)
    investors = find_by_name(investors) if search
    investors
  end

  private

  def find_by_name(investors)
    investors.select { |inv| inv.name =~ /#{search}/i }
  end
end
