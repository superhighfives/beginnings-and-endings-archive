FactoryGirl.define do

  sequence(:email) { |n| "hi+#{n}@charliegleason.com" }
  locations = %w(Melbourne Sydney Berlin Sweden New York)
  sequence(:location) { |n| locations[n % locations.length]}
  sequence(:latitude) { |n| 100 + n }
  sequence(:longitude) { |n| 100 + n }

  factory :marker do
      email
      location
      latitude
      longitude
    end

end
