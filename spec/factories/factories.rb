FactoryGirl.define do
  factory :user do
    id "12345"
    email "test@test.com"
    uuid "YGSHJKBEKJWKJHJKXNJKLDNWN"
    created_at DateTime.parse('1st Jan 2011')
  end
end
