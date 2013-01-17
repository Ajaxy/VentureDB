require 'spec_helper'

describe SubscriptionMailer do
  let(:approved_user) do
    sub = fabricate Subscription, email: "foo@bar.com", name: "John Doe"
    sub.create_user
  end

  describe "#approved" do
    let(:mail) { SubscriptionMailer.approved(approved_user) }

    it 'should have proper recipient' do
      mail.to.should eq [approved_user.email]
    end

    it "should contain user's login and password" do
      mail.body.encoded.should match(approved_user.email)
      mail.body.encoded.should match(approved_user.password)
    end
  end
end
