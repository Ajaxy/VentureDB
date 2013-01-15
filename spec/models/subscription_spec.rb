# encoding: utf-8
require "spec_helper"

describe Subscription do
  describe 'callbacks' do
    describe 'auto approve' do
      it 'fires #approve when AUTO_CONFIRM_SUBSCRIPTION is true' do
        subscription = Subscription.new(email: 'foo@bar.com', name: 'John Doe')
        subscription.stub(:auto_confirm_subscription?) { true }
        subscription.should_receive(:approve)
        subscription.save
      end

      it 'does not file #approve when AUTO_CONFIRM_SUBSCRIPTION is false' do
        subscription = Subscription.new(email: 'foo@bar.com', name: 'John Doe')
        subscription.stub(:auto_confirm_subscription?) { false }
        subscription.should_not_receive(:approve)
        subscription.save
      end
    end
  end

  describe 'validations' do
    it 'should validate uniqueness of email' do
      user = fabricate(Subscription, email: 'foo@example.com')
      subscription = Subscription.new(email: 'foo@example.com')
      subscription.should_not be_valid
      subscription.should have_at_least(1).errors_on(:email)
    end

    it 'should add error if user with email already exists' do
      user = fabricate(User, email: 'foo@example.com')
      subscription = Subscription.new(email: 'foo@example.com')
      subscription.should_not be_valid
      subscription.should have(1).errors_on(:email)
    end
  end

  describe "#create_user" do
    it "creates user with proper fields" do
      sub   = fabricate Subscription, email: "foo@bar.com", name: "John Doe"
      user  = sub.create_user

      user.email.should == "foo@bar.com"
      user.password.size.should == 8

      user.person.first_name.should == "John"
      user.person.last_name.should == "Doe"
    end

    it "understands full russian name" do
      sub   = fabricate Subscription, name: "Иванов Иван Иванович"
      user  = sub.create_user

      user.person.first_name.should == "Иван"
      user.person.last_name.should == "Иванов"
      user.person.middle_name.should == "Иванович"
    end
  end
end

