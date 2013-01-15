require 'spec_helper'

describe SearchController do
  describe "GET #suggest" do
    it "returns empty result when now allowed entity type passed" do
      get :suggest, query: 'foo', entities: 'bar', format: 'json'

      response.should be_success
      result = JSON.parse(response.body)
      result.should be_a Array
      result.should be_blank
    end
  end

  describe 'search for specific type' do
    before do
      fabricate(Investor, name: 'Test investor')
      fabricate(Project, name: 'Test project')
    end

    it "searches for investors" do
      get :suggest, query: 'test', entities: 'investor', format: 'json'

      response.should be_success
      result = JSON.parse(response.body)
      result.size.should eq 1
      result[0]["type"].should eq 'investor'
    end

    it "searches for project" do
      get :suggest, query: 'test', entities: 'project', format: 'json'

      response.should be_success
      result = JSON.parse(response.body)
      result.size.should eq 1
      result[0]["type"].should eq 'project'
    end
  end

  it "searches for mixed types" do
    fabricate(Investor, name: 'Test investor')
    fabricate(Project, name: 'Test project')

    get :suggest, query: 'test', entities: 'investor,project', format: 'json'

    response.should be_success
    result = JSON.parse(response.body)
    result.size.should eq 2
  end

  it "searches for all when 'all' type passed" do
    fabricate(Investor, name: 'Test investor')
    fabricate(Project, name: 'Test project')

    get :suggest, query: 'test', entities: 'all', format: 'json'

    response.should be_success
    result = JSON.parse(response.body)
    result.size.should eq 2
  end

  it 'seaches only by names' do
    fabricate(Investor, name: 'Test investor')
    fabricate(Project, name: 'Test project')
    fabricate(Project, name: 'Just project', description: 'test in description')

    get :suggest, query: 'test', entities: 'all', format: 'json'

    response.should be_success
    result = JSON.parse(response.body)
    result.size.should eq 2
  end

  it 'returns empty array when not found' do
    fabricate(Investor, name: 'Test investor')
    fabricate(Project, name: 'Test project')

    get :suggest, query: 'qwert', entities: 'all', format: 'json'

    response.should be_success
    result = JSON.parse(response.body)
    result.size.should eq 0
  end

  it "returns no more than SEARCH_AUTOSUGGEST_LIMIT entities" do
    (SEARCH_AUTOSUGGEST_LIMIT + 1).times do |i|
      fabricate(Investor, name: "Test investor #{i}")
    end

    get :suggest, query: 'test', entities: 'investor', format: 'json'

    response.should be_success
    result = JSON.parse(response.body)
    result.size.should eq SEARCH_AUTOSUGGEST_LIMIT
  end
end
