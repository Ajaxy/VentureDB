class Angel < Person
  include HasInvestments
  include InvestorActor
  include Searchable
end