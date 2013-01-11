require 'spec_helper'

describe SearchController do
  describe "GET #suggest" do
    it "returns empty result when now allowed entity type passed" do
      get :suggest, query: 'foo', entites: 'bar', format: 'json'

      response.should be_success
      result = JSON.parse(response.body)
      result.should be_a Array
      result.should be_blank
    end
  end

  it "searches for specified type and return json" do
    fabricate(Investor, name: 'Test investor 1')
    fabricate(Investor, name: 'Test investor 2')
    fabricate(Investor, name: 'Another investor')

    get :suggest, query: 'test', entites: 'investor', format: 'json'

    response.should be_success
    result = JSON.parse(response.body)
    result.size.should eq 2
  end

  it "searches for mixed types" do
    fabricate(Investor, name: 'Test investor')
    fabricate(Project, name: 'Test project')

    get :suggest, query: 'test', entites: 'investor,project', format: 'json'

    response.should be_success
    result = JSON.parse(response.body)
    result.size.should eq 2
  end

  it "returns no more than SEARCH_AUTOSUGGEST_LIMIT entites" do
    (SEARCH_AUTOSUGGEST_LIMIT + 1).times do |i|
      fabricate(Investor, name: "Test investor #{i}")
    end

    get :suggest, query: 'test', entites: 'investor', format: 'json'

    response.should be_success
    result = JSON.parse(response.body)
    result.size.should eq SEARCH_AUTOSUGGEST_LIMIT
  end
end
