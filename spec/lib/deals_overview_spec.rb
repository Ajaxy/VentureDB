# encoding: utf-8
require "spec_helper"

describe DealsOverview do
  MONEY_RATE = 1_000_000

  def create_deal(options = {})
    scopes    = options.delete(:scopes)
    locations = options.delete(:locations)
    investors = options.delete(:investors)

    deal      = fabricate(Deal, options.merge(published: true))

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
    current_year = Time.now.year

    deal1 = create_deal(amount_usd: 0)
    deal2 = create_deal(contract_date: Date.new(current_year - 1, 1, 10), amount_usd: 0)
    deal3 = create_deal(contract_date: Date.new(current_year, 1, 10), amount_usd: 0)
    deal4 = create_deal(contract_date: Date.new(current_year, 3, 10), amount_usd: 0)

    overview.deals.should == [deal1, deal2, deal3, deal4]
    overview(year: current_year - 2).deals.should == []
    overview(year: current_year - 1).deals.should == [deal2]
    overview(year: current_year).deals.should == [deal3, deal4]
  end

  it "shows total values" do
    current_year = Time.now.year

    investor1 = fabricate Investor
    investor2 = fabricate Investor
    project1  = fabricate Project
    project2  = fabricate Project

    create_deal(amount_usd: 0)
    create_deal(contract_date: Date.new(current_year - 2, 12, 31), amount_usd: 10 * MONEY_RATE)

    create_deal(contract_date: Date.new(current_year - 1, 12, 31), amount_usd: 20 * MONEY_RATE,
                investors: [investor1], project: project1)

    create_deal(contract_date: Date.new(current_year - 1, 1, 10), amount_usd: 30 * MONEY_RATE,
                investors: [investor1], project: project1)

    create_deal(contract_date: Date.new(current_year, 3, 10), amount_usd: 40 * MONEY_RATE,
                investors: [investor1, investor2], project: project1)

    create_deal(contract_date: Date.new(current_year, 4, 10), amount_usd: 50 * MONEY_RATE,
                investors: [investor2], project: project2)

    overview(year: current_year - 2).totals.investors.should == 0
    overview(year: current_year - 2).totals.projects.should  == 0

    overview(year: current_year - 1).totals.investors.should == 1
    overview(year: current_year - 1).totals.projects.should  == 1

    overview(year: current_year).totals.investors.should == 2
    overview(year: current_year).totals.projects.should  == 2
  end

  describe "directions" do
    it "groups data by project scopes" do
      scope1 = fabricate(Scope, name: "foo")
      scope2 = fabricate(Scope, name: "bar")
      scope3 = fabricate(Scope, name: "foo/sub").move_to_child_of(scope1)

      deal1 = create_deal(amount_usd: 0)
      deal2 = create_deal(scopes: [scope1], stage_id: 1, amount_usd: 10 * MONEY_RATE)
      deal3 = create_deal(scopes: [scope2], stage_id: 2, amount_usd: 20 * MONEY_RATE)
      deal4 = create_deal(scopes: [scope1, scope3], amount_usd: 30 * MONEY_RATE)

      overview.directions.series.should == overview.root_directions.series

      overview.deals.size.should == 4
      overview.deals.should      == [deal1, deal2, deal3, deal4]

      directions = overview.directions.series
      directions.size.should == 2

      directions[0].scope.should  == scope1
      directions[0].count.should  == 2
      directions[0].millions.should == 40

      directions[0].for_stage(1).count.should  == 1
      directions[0].for_stage(1).millions.should == 10

      directions[0].for_stage(nil).count.should   == 1
      directions[0].for_stage(nil).millions.should  == 30

      directions[1].scope.should  == scope2
      directions[1].count.should  == 1
      directions[1].millions.should == 20

      directions[1].for_stage(2).count.should   == 1
      directions[1].for_stage(2).millions.should  == 20

      directions[1].for_stage(nil).count.should   == 0
      directions[1].for_stage(nil).millions.should  == 0
    end

    it "groups data by scope if subscopes of the same scope present" do
      scope1 = fabricate(Scope, name: "foo")
      scope2 = fabricate(Scope, name: "foo/sub1").move_to_child_of(scope1)
      scope3 = fabricate(Scope, name: "foo/sub2").move_to_child_of(scope1)
      scope4 = fabricate(Scope, name: "bar")

      deal1 = create_deal(scopes: [scope2, scope3], amount_usd: 30 * MONEY_RATE)
      deal2 = create_deal(scopes: [scope4],         amount_usd: 40 * MONEY_RATE)

      overview.deals.size.should == 2
      overview.deals.should      == [deal1, deal2]

      directions = overview.directions.series
      directions.size.should == 2

      directions[0].count.should == 1
      directions[0].millions.should == 40
      directions[1].count.should == 1
      directions[1].millions.should == 30
    end

    it "groups data by sub-scope if scope is passed" do
      scope1 = fabricate(Scope, name: "foo")
      scope2 = fabricate(Scope, name: "foo/sub1").move_to_child_of(scope1)
      scope3 = fabricate(Scope, name: "foo/sub2").move_to_child_of(scope1)
      scope4 = fabricate(Scope, name: "foo/sub3").move_to_child_of(scope1)
      scope5 = fabricate(Scope, name: "bar")

      deal1 = create_deal
      deal2 = create_deal(scopes: [scope1],         amount_usd: 10 * MONEY_RATE)
      deal3 = create_deal(scopes: [scope2],         amount_usd: 20 * MONEY_RATE)
      deal4 = create_deal(scopes: [scope2, scope3], amount_usd: 30 * MONEY_RATE)
      deal5 = create_deal(scopes: [scope5],         amount_usd: 40 * MONEY_RATE)

      overview = overview(scope: scope1.id)

      overview.deals.size.should == 3
      overview.deals.should      == [deal2, deal3, deal4]

      root_directions = overview.root_directions.series
      root_directions.size.should == 2

      root_directions[0].scope.should  == scope1
      root_directions[0].count.should  == 3
      root_directions[0].millions.should == 60

      root_directions[1].scope.should  == scope5
      root_directions[1].count.should  == 1
      root_directions[1].millions.should == 40

      directions = overview.directions.series
      directions.size.should == 3

      directions[0].scope.should  == scope2
      directions[0].count.should  == 2
      directions[0].millions.should == 50

      directions[1].scope.should  == scope3
      directions[1].count.should  == 1
      directions[1].millions.should == 30

      directions[2].scope.should  == scope1
      directions[2].count.should  == 1
      directions[2].millions.should == 10
    end
  end

  describe "geography" do
    it "groups data by location" do
      location1 = fabricate(Location, x: 1)
      location2 = fabricate(Location, x: 1)
      location3 = fabricate(Location, x: 1).move_to_child_of(location1)

      create_deal
      create_deal(locations: [location1],            amount_usd: 10 * MONEY_RATE)
      create_deal(locations: [location3, location2], amount_usd: 20 * MONEY_RATE)

      locations = overview.geography.series
      locations.size.should == 2

      locations[0].millions.should == 30
      locations[0].count.should  == 2

      locations[1].millions.should == 20
      locations[1].count.should  == 1
    end
  end

  # describe "dynamics" do
  #   it "groups data by quarters if year is passed" do
  #     deal1 = create_deal
  #     deal2 = create_deal(contract_date: "10.01.2012", amount_usd: 10 * MONEY_RATE)
  #     deal3 = create_deal(contract_date: "10.03.2012", amount_usd: 20 * MONEY_RATE)
  #     deal4 = create_deal(contract_date: "10.04.2012", amount_usd: 30 * MONEY_RATE)

  #     overview = overview(year: 2012)

  #     overview.deals.size.should == 3
  #     overview.deals.should      == [deal2, deal3, deal4]

  #     periods = overview.dynamics.series
  #     periods.size.should == 4

  #     periods[0].average_amount.should == 15
  #     periods[1].average_amount.should == 30
  #     periods[2].average_amount.should == 0
  #     periods[3].average_amount.should == 0
  #   end

  #   it "groups data by last 3 years if no year is passed" do
  #     create_deal(amount_usd: 0)
  #     create_deal(contract_date: "31.12.2011", amount_usd: 10 * MONEY_RATE)
  #     create_deal(contract_date: "10.01.2012", amount_usd: 20 * MONEY_RATE)
  #     create_deal(contract_date: "10.03.2012", amount_usd: 30 * MONEY_RATE)
  #     create_deal(contract_date: "10.04.2012", amount_usd: 40 * MONEY_RATE)

  #     overview.deals.size.should == 5

  #     periods = overview.dynamics.series
  #     periods.size.should == 3

  #     periods[0].average_amount.should == 0
  #     periods[1].average_amount.should == 10
  #     periods[2].average_amount.should == 30
  #   end
  # end

  describe "stages" do
    before do
      create_deal(amount_usd: 5 * MONEY_RATE)
      create_deal(stage_id: 3, amount_usd: 10 * MONEY_RATE)
      create_deal(stage_id: 1, amount_usd: 20 * MONEY_RATE)
      create_deal(stage_id: 4, amount_usd: 30 * MONEY_RATE)
      create_deal(stage_id: 1, amount_usd: 40 * MONEY_RATE)
    end

    it "groups data by deal stage" do
      stages = overview.stages

      stages.series.size.should == 6

      stages.data_for(nil).count.should  == 1
      stages.data_for(nil).millions.should == 5

      stages.data_for(1).count.should  == 2
      stages.data_for(1).millions.should == 60

      stages.data_for(3).count.should  == 1
      stages.data_for(3).millions.should == 10

      stages.data_for(4).count.should  == 1
      stages.data_for(4).millions.should == 30
    end

    it "show only stages with deals on chart" do
      series = overview.stages.chart.series

      series.size.should == 3

      series[0].count.should  == 2
      series[0].millions.should == 60

      series[1].count.should  == 1
      series[1].millions.should == 10

      series[2].count.should  == 1
      series[2].millions.should == 30
    end
  end

  describe "rounds" do
    before do
      create_deal(amount_usd: 5 * MONEY_RATE)
      create_deal(round_id: 4, amount_usd: 10 * MONEY_RATE)
      create_deal(round_id: 1, amount_usd: 20 * MONEY_RATE)
      create_deal(round_id: 3, amount_usd: 30 * MONEY_RATE)
      create_deal(round_id: 1, amount_usd: 40 * MONEY_RATE)
      create_deal(round_id: 4, amount_usd: 50 * MONEY_RATE)
    end

    it "groups data by deal round" do
      rounds = overview.rounds

      rounds.series.size.should == 6

      rounds.data_for(nil).count.should  == 1
      rounds.data_for(nil).millions.should == 5

      rounds.data_for(1).count.should  == 2
      rounds.data_for(1).millions.should == 60

      rounds.data_for(3).count.should  == 1
      rounds.data_for(3).millions.should == 30

      rounds.data_for(4).count.should  == 2
      rounds.data_for(4).millions.should == 60
    end

    it "show only rounds with deals on chart" do
      series = overview.rounds.chart.series

      series.size.should == 3

      series[0].count.should  == 2
      series[0].millions.should == 60

      series[1].count.should  == 1
      series[1].millions.should == 30

      series[2].count.should  == 2
      series[2].millions.should == 60
    end
  end
end
