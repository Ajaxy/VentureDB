# encoding: utf-8
require "spec_helper"

describe DynamicsChart do
  describe DynamicsChart::Quarter do
    it "sets proper quarter" do
      q = DynamicsChart::Quarter.new(2012, 1)
      q.period.should == (Date.new(2012, 1) .. Date.new(2012, 3))
      q.name.should == "2012/1"

      q = DynamicsChart::Quarter.new(2012, 0)
      q.period.should == (Date.new(2011, 10) .. Date.new(2011, 12))
      q.name.should == "2011/4"

      q = DynamicsChart::Quarter.new(2012, -1)
      q.period.should == (Date.new(2011, 7) .. Date.new(2011, 9))
      q.name.should == "2011/3"

      q = DynamicsChart::Quarter.new(2012, -5)
      q.period.should == (Date.new(2010, 7) .. Date.new(2010, 9))
      q.name.should == "2010/3"
    end
  end
end
