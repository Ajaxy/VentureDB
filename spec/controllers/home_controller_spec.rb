require 'spec_helper'

describe HomeController do
  include Devise::TestHelpers

  describe "POST #subscribe" do
    context "when not registered yet" do
      it "creates subscription and responds with success" do
        expect do
          post :subscribe, subscription: { email: 'foo@example.com',
            name: 'John Doe', company: 'Example' }, format: 'json'
        end.to change{Subscription.count}.by(1)

        response.should be_success
      end
    end

    context "when already registered" do
      it "sends remind email to user" do
        user = fabricate(User, email: 'foo@example.com')
        mail = double("mail")
        UserMailer.should_receive(:remind_already_registered).with(user) { mail }
        mail.should_receive(:deliver)

        expect do
          post :subscribe, subscription: { email: 'foo@example.com',
            name: 'John Doe', company: 'Example' }, format: 'json'
        end.to change{Subscription.count}.by(0)

        response.should be_success
      end
    end
  end
end
