# encoding: utf-8
require "spec_helper"

describe Subscription do
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

