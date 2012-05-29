FactoryGirl.define do
  sequence(:email)       {|n| "person#{n}@example.com" }

  factory :identity, :class => EdgeAuth::Identity  do |identity|
  	identity.email                  { FactoryGirl.generate :email }
    identity.password              'foobar'
    identity.password_confirmation 'foobar'
    identity.activation_code       '1234567890'
    identity.state                 'active'
  end
end
