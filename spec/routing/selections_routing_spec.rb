require "spec_helper"

describe SelectionsController do
  describe "routing" do

    it "routes to #index" do
      get("/selections").should route_to("selections#index")
    end

    it "routes to #new" do
      get("/selections/new").should route_to("selections#new")
    end

    it "routes to #show" do
      get("/selections/1").should route_to("selections#show", :id => "1")
    end

    it "routes to #edit" do
      get("/selections/1/edit").should route_to("selections#edit", :id => "1")
    end

    it "routes to #create" do
      post("/selections").should route_to("selections#create")
    end

    it "routes to #update" do
      put("/selections/1").should route_to("selections#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/selections/1").should route_to("selections#destroy", :id => "1")
    end

  end
end
