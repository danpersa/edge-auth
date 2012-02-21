Factory.sequence(:email)       {|n| "person#{n}@example.com" }

FactoryGirl.define do
  factory :identity, :class => EdgeAuth::Identity  do |identity|
  	identity.email                  { Factory.next :email }

    identity.password              'foobar'
    identity.password_confirmation 'foobar'
    identity.activation_code       '1234567890'
    identity.state                 'active'
  end
end
