# encoding: utf-8
require "spec_helper"

describe DealsOverview do
  MONEY_RATE = Deal::DEFAULT_DOLLAR_RATE * 1_000_000

  def fabricate(klass, options = {})
    klass.new(options).tap { |model| model.save!(validate: false) }
  end

  def create_deal(options = {})
    scopes    = options.delete(:scopes)
    locations = options.delete(:locations)
    investors = options.delete(:investors)

    deal      = fabricate(Deal, options)

    if scopes
      project = fabricate(Project, scopes: scopes)
      deal.update_column :project_id, project.id
    end

    if locations
      investors = [ fabricate(Investor, locations: locations) ]
    end

    if investors
      investors.each do |investor|
        fabricate(Investment, investor: investor, deal: deal)
      end
    end

    deal
  end

  def overview(options = {})
    @overviews ||= {}
    return @overviews[options] if @overviews[options]
    @overviews[options] = DealsOverview.new(options)
  end

  it "selects only deals for passed year" do
    deal1 = create_deal
    deal2 = create_deal(contract_date: "10.01.2011")
    deal3 = create_deal(contract_date: "10.01.2012")
    deal4 = create_deal(contract_date: "10.03.2012")

    overview.deals.should == [deal1, deal2, deal3, deal4]
    overview(year: 2010).deals.should == []
    overview(year: 2011).deals.should == [deal2]
    overview(year: 2012).deals.should == [deal3, deal4]
  end

  it "shows total values" do
    investor1 = fabricate Investor
    investor2 = fabricate Investor
    project1  = fabricate Project
    project2  = fabricate Project

    create_deal
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
    overview.count.should  == 6

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

      deal1 = create_deal
      deal2 = create_deal(scopes: [scope1],         amount: 10 * MONEY_RATE)
      deal3 = create_deal(scopes: [scope2],         amount: 20 * MONEY_RATE)
      deal4 = create_deal(scopes: [scope1, scope3], amount: 30 * MONEY_RATE)

      overview.directions.series.should == overview.root_directions.series

      overview.deals.size.should == 4
      overview.deals.should      == [deal1, deal2, deal3, deal4]

      directions = overview.directions.series
      directions.size.should == 2

      directions[0].scope.should  == scope1
      directions[0].count.should  == 3
      directions[0].amount.should == 70

      directions[1].scope.should  == scope2
      directions[1].count.should  == 1
      directions[1].amount.should == 20
    end

    it "groups date by sub-scope if scope is passed" do
      scope1 = fabricate(Scope, name: "foo")
      scope2 = fabricate(Scope, name: "foo/sub1").move_to_child_of(scope1)
      scope3 = fabricate(Scope, name: "foo/sub2").move_to_child_of(scope1)
      scope4 = fabricate(Scope, name: "foo/sub3").move_to_child_of(scope1)

      deal1 = create_deal
      deal2 = create_deal(scopes: [scope1],         amount: 10 * MONEY_RATE)
      deal3 = create_deal(scopes: [scope2],         amount: 20 * MONEY_RATE)
      deal4 = create_deal(scopes: [scope2, scope3], amount: 30 * MONEY_RATE)

      overview = overview(scope: scope1.id)

      overview.deals.size.should == 3
      overview.deals.should      == [deal2, deal3, deal4]

      root_directions = overview.root_directions.series
      root_directions.size.should == 1

      root_directions[0].scope.should  == scope1
      root_directions[0].count.should  == 4
      root_directions[0].amount.should == 90

      directions = overview.directions.series
      directions.size.should == 2

      directions[0].scope.should  == scope2
      directions[0].count.should  == 2
      directions[0].amount.should == 50

      directions[1].scope.should  == scope3
      directions[1].count.should  == 1
      directions[1].amount.should == 30
    end
  end

  describe "geography" do
    it "groups data by location" do
      location1 = fabricate(Location)
      location2 = fabricate(Location)
      location3 = fabricate(Location).move_to_child_of(location1)

      create_deal
      create_deal(locations: [location1],            amount: 10 * MONEY_RATE)
      create_deal(locations: [location3, location2], amount: 20 * MONEY_RATE)

      locations = overview.geography.series
      locations.size.should == 2

      locations[0].amount.should == 30
      locations[0].count.should  == 2

      locations[1].amount.should == 20
      locations[1].count.should  == 1
    end
  end

  describe "dynamics" do
    it "groups data by quarters if year is passed" do
      deal1 = create_deal
      deal2 = create_deal(contract_date: "10.01.2012", amount: 10 * MONEY_RATE)
      deal3 = create_deal(contract_date: "10.03.2012", amount: 20 * MONEY_RATE)
      deal4 = create_deal(contract_date: "10.04.2012", amount: 30 * MONEY_RATE)

      overview = overview(year: 2012)

      overview.deals.size.should == 3
      overview.deals.should      == [deal2, deal3, deal4]

      periods = overview.dynamics.series
      periods.size.should == 4

      periods[0].average_amount.should == 15
      periods[1].average_amount.should == 30
      periods[2].average_amount.should == 0
      periods[3].average_amount.should == 0
    end

    it "groups data by last 3 years if no year is passed" do
      create_deal
      create_deal(contract_date: "31.12.2011", amount: 10 * MONEY_RATE)
      create_deal(contract_date: "10.01.2012", amount: 20 * MONEY_RATE)
      create_deal(contract_date: "10.03.2012", amount: 30 * MONEY_RATE)
      create_deal(contract_date: "10.04.2012", amount: 40 * MONEY_RATE)

      overview.deals.size.should == 5

      periods = overview.dynamics.series
      periods.size.should == 3

      periods[0].average_amount.should == 0
      periods[1].average_amount.should == 10
      periods[2].average_amount.should == 30
    end
  end

  describe "stages" do
    it "groups data by deal stage" do
      create_deal
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
      create_deal
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
