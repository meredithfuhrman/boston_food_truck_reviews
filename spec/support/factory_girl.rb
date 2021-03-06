require 'factory_girl'
FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
    user_type "Member"
  end

  factory :vendor do
    sequence(:vendor_name) { |n| "Vendor #{n}" }
    viewable true
  end

  factory :review do
    rating 4
    body "This is a test review lala lala lala"
    vendor
    user
  end

  factory :category do
    category_name 'Breakfast'
  end

  factory :comment do
    review
    user
    comment_body 'yayayayayayayyaya'
  end

end
