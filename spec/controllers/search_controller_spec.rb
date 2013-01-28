# encoding: utf-8

require 'spec_helper'
require 'support/sphinx_environment'

describe SearchController do
  include Devise::TestHelpers

  let(:user) { fabricate(User) }
  before (:each) { sign_in user }

  describe "GET #suggest" do
    it "returns empty result when now allowed entity type passed" do
      get :suggest, query: 'foo', entities: 'bar', format: 'json'

      response.should be_success
      result = JSON.parse(response.body)
      result.should be_a Array
      result.should be_blank
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

  describe "GET #index" do
    it "left @records unassigned when no query was passed" do
      get :index
      assigns(:records).should be_nil
    end

    sphinx_environment :deals, :projects, :investors, :users do
      it "searches for deals, projects and investors" do
        investor = fabricate(Investor, name: 'Test investor')
        project1 = fabricate(Project, description: 'Test project')
        project2 = fabricate(Project, name: 'Test project')
        deal = fabricate(Deal, project_id: project2.id, published: true)

        ThinkingSphinx::Test.index

        get :index, search: 'test'

        assigns(:records).map(&:model).should =~ [investor, project1, project2, deal]
      end

      it "finds records with words permutations" do
        investor = fabricate(Investor, name: 'Павел Черкашин')

        ThinkingSphinx::Test.index

        get :index, search: "Черкашин Павел"
        assigns(:records).map(&:model).should =~ [investor]
      end

      it "find records with query as a part of word" do
        investor = fabricate(Investor, name: "Microsoft")

        ThinkingSphinx::Test.index

        get :index, search: "micro"
        assigns(:records).map(&:model).should =~ [investor]
      end

      it "finds records with extra words" do
        project = fabricate(Project, name: "Социальные прекрасные сети")

        ThinkingSphinx::Test.index

        get :index, search: "социальные сети"
        assigns(:records).map(&:model).should =~ [project]
      end

      it "takes in account russian morphology" do
        project1 = fabricate(Project, name: "Социальные сети", draft: false)
        project2 = fabricate(Project, name: "Социальная сеть", draft: false)
        project3 = fabricate(Project, name: "Социальных сетей", draft: false)

        ThinkingSphinx::Test.index

        get :index, search: "социальные"
        assigns(:records).map(&:model).should =~ [project1, project2, project3]
      end
    end
  end
end
