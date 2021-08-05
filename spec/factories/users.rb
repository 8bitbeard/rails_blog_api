FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    uid { email }
    password { '12345678' }
    # confirm_password { '12345678' }

    factory :confirmed_user do
      confirmed_at { Time.now }
    end

    factory :user_without_uid do
      uid { '' }
    end
  end
end
