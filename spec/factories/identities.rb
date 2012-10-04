FactoryGirl.define do
  sequence(:email)       {|n| "person#{n}@example.com" }

  factory :user, :class => EdgeAuth::User  do |user|
  	user.email                  { FactoryGirl.generate :email }
    user.password              'foobar'
    user.password_confirmation 'foobar'
    user.activation_code       '1234567890'
    user.state                 'active'
  end
end
