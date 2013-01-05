FactoryGirl.define do
  sequence(:email)       {|n| "person#{n}@example.com" }

  factory :user, :class => EdgeAuth::User  do |user|
    user.email                  { FactoryGirl.generate :email }
    user.password              'foobar'
    user.password_confirmation 'foobar'
    user.activation_code       '1234567890'
    user.state                 'active'
    user.activated_at          Time.now.utc
  end

  factory :pending_user, :class => EdgeAuth::User  do |user|
    user.email                  { FactoryGirl.generate :email }
    user.password              'foobar'
    user.password_confirmation 'foobar'
    user.activation_code       '1234567890'
    user.state                 'pending'
  end

  factory :activated_user, :class => EdgeAuth::User  do |user|
    user.email                 'jordan.activated@example.com'
    user.password              'foobar'
    user.password_confirmation 'foobar'
    user.state                 'active'
    user.activated_at          Time.now.utc
  end

  factory :unique_user, :class => EdgeAuth::User do |user|
    user.email                  { FactoryGirl.generate :email }

    user.password              'foobar'
    user.password_confirmation 'foobar'
    user.activation_code       '1234567890'
    user.state                 'pending'
  end
end
