# encoding: utf-8
require "spec_helper"

describe DealsOverview do
  MONEY_RATE = Deal::DEFAULT_DOLLAR_RATE * 1_000_000

  def fabricate(klass, options = {})
    klass.new(options).tap { |model| model.save!(validate: false) }
  end

  def create_deal(options = {})
    scopes    = options.delete(:scopes)
    investors = options.delete(:investors)

    deal      = fabricate(Deal, options)

    if scopes
      project = fabricate(Project, scopes: scopes)
      deal.update_column :project_id, project.id
    end

    if investors
      investors.each do |investor|
        fabricate(Investment, investor: investor, deal: deal)
      end
    end

    deal
  end

  def overview(options = {})
    DealsOverview.new(options)
  end

  it "selects only deals for passed year" do
    deal1 = create_deal(contract_date: "10.01.2011")
    deal2 = create_deal(contract_date: "10.01.2012")
    deal3 = create_deal(contract_date: "10.03.2012")

    overview.deals.should == [deal1, deal2, deal3]
    overview(year: 2010).deals.should == []
    overview(year: 2011).deals.should == [deal1]
    overview(year: 2012).deals.should == [deal2, deal3]
  end

  it "shows total values" do
    investor1 = fabricate Investor
    investor2 = fabricate Investor
    project1  = fabricate Project
    project2  = fabricate Project

    create_deal(contract_date: "31.12.2010", amount: 10 * MONEY_RATE)

    create_deal(contract_date: "31.12.2011", amount: 20 * MONEY_RATE,
                investors: [investor1], project: project1)

    create_deal(contract_date: "10.01.2011", amount: 30 * MONEY_RATE,
                investors: [investor1], project: project1)

    create_deal(contract_date: "10.03.2012", amount: 40 * MONEY_RATE,
                investors: [investor1, investor2], project: project1)

    create_deal(contract_date: "10.04.2012", amount: 50 * MONEY_RATE,
                investors: [investor2], project: project2)

    overview.amount.should == 150
    overview.count.should  == 5

    overview(year: 2010).amount.should    == 10
    overview(year: 2010).count.should     == 1
    overview(year: 2010).investors.should == 0
    overview(year: 2010).projects.should  == 0

    overview(year: 2011).amount.should    == 50
    overview(year: 2011).count.should     == 2
    overview(year: 2011).investors.should == 1
    overview(year: 2011).projects.should  == 1

    overview(year: 2012).amount.should    == 90
    overview(year: 2012).count.should     == 2
    overview(year: 2012).investors.should == 2
    overview(year: 2012).projects.should  == 2
  end

  describe "directions" do
    it "groups data by project scopes" do
      scope1 = fabricate(Scope, name: "foo")
      scope2 = fabricate(Scope, name: "bar")
      scope3 = fabricate(Scope, name: "foo/sub").move_to_child_of(scope1)

      create_deal(scopes: [scope1])
      create_deal(scopes: [scope2])
      create_deal(scopes: [scope1, scope3])

      directions = overview.directions.series

      directions[0].scope.should == scope1
      directions[0].count.should == 3

      directions[1].scope.should == scope2
      directions[1].count.should == 1
    end
  end

  describe "dynamics" do
    it "groups data by quarters if year is passed" do
      create_deal(contract_date: "10.01.2012", amount: 10 * MONEY_RATE)
      create_deal(contract_date: "10.03.2012", amount: 20 * MONEY_RATE)
      create_deal(contract_date: "10.04.2012", amount: 30 * MONEY_RATE)

      periods = overview(year: 2012).dynamics.series
      periods.size.should == 4

      periods[0].average_amount.should == 15
      periods[1].average_amount.should == 30
      periods[2].average_amount.should == 0
      periods[3].average_amount.should == 0
    end

    it "groups data by last 3 years if no year is passed" do
      create_deal(contract_date: "31.12.2011", amount: 10 * MONEY_RATE)
      create_deal(contract_date: "10.01.2012", amount: 20 * MONEY_RATE)
      create_deal(contract_date: "10.03.2012", amount: 30 * MONEY_RATE)
      create_deal(contract_date: "10.04.2012", amount: 40 * MONEY_RATE)

      periods = overview.dynamics.series
      periods.size.should == 3

      periods[0].average_amount.should == 0
      periods[1].average_amount.should == 10
      periods[2].average_amount.should == 30
    end
  end

  describe "stages" do
    it "groups data by deal stage" do
      create_deal(stage_id: 1, amount: 10 * MONEY_RATE)
      create_deal(stage_id: 1, amount: 20 * MONEY_RATE)
      create_deal(stage_id: 3, amount: 30 * MONEY_RATE)
      create_deal(stage_id: 4, amount: 40 * MONEY_RATE)

      stages = overview.stages.series
      stages.size.should == 3

      stages[0].name.should   == "#{Deal::STAGES[1]} (2)"
      stages[0].amount.should == 30

      stages[1].name.should   == "#{Deal::STAGES[3]} (1)"
      stages[1].amount.should == 30

      stages[2].name.should   == "#{Deal::STAGES[4]} (1)"
      stages[2].amount.should == 40
    end
  end

  describe "rounds" do
    it "groups data by deal round" do
      create_deal(round_id: 1, amount: 10 * MONEY_RATE)
      create_deal(round_id: 1, amount: 20 * MONEY_RATE)
      create_deal(round_id: 3, amount: 30 * MONEY_RATE)
      create_deal(round_id: 4, amount: 40 * MONEY_RATE)
      create_deal(round_id: 4, amount: 50 * MONEY_RATE)

      rounds = overview.rounds.series
      rounds.size.should == 3

      rounds[0].count.should  == 2
      rounds[0].amount.should == 30

      rounds[1].count.should  == 1
      rounds[1].amount.should == 30

      rounds[2].count.should  == 2
      rounds[2].amount.should == 90
    end
  end
end
