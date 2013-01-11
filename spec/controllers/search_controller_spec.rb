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
end
