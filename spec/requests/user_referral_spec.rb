require 'requests_helper'

describe "User referrals" do

  describe "receiving a link" do

    before do
      @marker = Factory(:marker)
    end

    it "should not redirect the user to the non-referral join" do
      visit "/join/#{@marker.code}"
      current_path.should == "/join/#{@marker.code}"
    end

  end

end
