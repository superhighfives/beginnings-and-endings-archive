require 'spec_helper'

describe Marker do

  describe "validations" do

    it "should require an email address" do
      expect { Factory(:marker, email: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    context "uniqueness of emails" do

      let(:email) { 'you@beingawesome.com' }
      it "should be a unique email address" do
        Factory(:marker, email: :email)
        expect { Factory(:marker, email: :email) }.to raise_error(ActiveRecord::RecordInvalid)
      end

    end

    it "should require a location" do
      expect { Factory(:marker, location: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should require a latitude" do
      expect { Factory(:marker, latitude: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should require a longitude" do
      expect { Factory(:marker, longitude: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "should have a unique short code" do
      marker = Factory(:marker)
      marker.code.should == (marker.id + 10000).base62_encode
    end

    context "referral code" do

      before do
        @marker = Factory(:marker)
        @new_marker = Factory(:marker, referrer_code: @marker.code)
      end

      it "should allow the user to sign up using an existing referral code" do
        @new_marker.referrer_code.should == @marker.code
      end

      it "should increment the referrer count when a user signs up using an existing referral code" do
        @marker.reload
        @marker.num_referred.should == 1
      end

      it "should not increment the referrer count when a user signs up without a referral code" do
        @new_marker.reload
        @new_marker.num_referred.should == 0
      end
    end

  end

end
