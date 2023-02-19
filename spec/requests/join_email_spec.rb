require 'requests_helper'

describe "Join emails" do

  describe "sending an email" do

    before do
      @marker = Factory(:marker)
      @marker.send_email
      @invite_url = "http://beginnings.wearebrightly.com/join/#{@marker.code}"
    end

    it "should have a link to the join page" do
      email = ActionMailer::Base.deliveries.last
      email.to.should include(@marker.email)
      email.subject.should == "Thanks for joining!"
      email.body.should have_content("Thanks for joining the Beginnings & Endings project.")
      email.body.should have_css("a[href='#{@invite_url}']")

      visit @invite_url
      page.should have_content("You're using the code: #{@marker.code}")
    end

  end

end
