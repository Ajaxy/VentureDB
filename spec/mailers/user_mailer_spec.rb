require 'spec_helper'

describe UserMailer do
  include Rails.application.routes.url_helpers

  let(:user) { fabricate(User, email: 'foo@example.com') }

  describe "#remind_already_registered" do
    before { user.send(:generate_reset_password_token!)}

    let(:mail) { UserMailer.remind_already_registered(user) }

    it "should have proper recipient" do
      mail.to.should eq [user.email]
    end

    it "should contain link for password reset" do
      password_reset_url = edit_user_password_url(reset_password_token: user.reset_password_token)
      mail.body.encoded.should match(Regexp.escape(password_reset_url))
    end
  end
end
