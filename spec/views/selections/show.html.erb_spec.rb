require 'spec_helper'

describe "selections/show" do
  before(:each) do
    @selection = assign(:selection, stub_model(Selection,
      :person => nil,
      :filter => "MyText",
      :mailing => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/MyText/)
    rendered.should match(/false/)
  end
end
