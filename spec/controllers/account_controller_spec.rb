require 'spec_helper'

describe AccountController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit'
      response.should be_success
    end
  end

  describe "GET 'plan'" do
    it "returns http success" do
      get 'plan'
      response.should be_success
    end
  end

end
