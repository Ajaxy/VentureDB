# encoding: utf-8
require "spec_helper"

describe Investor do
  let(:person)  { fabricate Person, first_name: "John", last_name: "Doe" }
  let(:company) { fabricate Company, name: "Foo" }

  before { investor }

  context "person" do
    let(:investor) { fabricate Investor, actor: person }

    it "should set name to the person name" do
      investor[:name].should == "John Doe"
    end

    it "should update name when person changes name" do
      person.last_name = "Brown"
      person.save
      investor.reload[:name].should == "John Brown"
    end
  end

  context "company" do
    let(:investor) { fabricate Investor, actor: company }

    it "should set name to the company name" do
      investor[:name].should == "Foo"
    end

    it "should update name when company changes name" do
      company.name = "Bar"
      company.save
      investor.reload[:name].should == "Bar"
    end
  end
end

