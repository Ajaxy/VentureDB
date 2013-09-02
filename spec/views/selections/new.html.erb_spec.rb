require 'spec_helper'

describe "selections/new" do
  before(:each) do
    assign(:selection, stub_model(Selection,
      :person => nil,
      :filter => "MyText",
      :mailing => false
    ).as_new_record)
  end

  it "renders new selection form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", selections_path, "post" do
      assert_select "input#selection_person[name=?]", "selection[person]"
      assert_select "textarea#selection_filter[name=?]", "selection[filter]"
      assert_select "input#selection_mailing[name=?]", "selection[mailing]"
    end
  end
end
