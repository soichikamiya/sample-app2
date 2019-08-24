FactoryBot.define do
  factory :user do
    # データを生成する毎に通し番号をふってユニークな値を作る
    sequence(:name) { |n| "TestName-#{n}"}
    sequence(:email) { |n| "Test-#{n}@example.com"}
    sequence(:password) { |n| "Password#{n}"}
    sequence(:password_confirmation) { |n| "Password#{n}"}
    activated { true }
    activated_at { Time.zone.now }
  end

  # Userクラスでモデル名以外の名前を作成
  factory :testuser, class: User do
    name { "TaroTanaka" }
    email { "testuser@test.com" }
    # password_digest { User.digest("password") }
    password { "password" }
    password_confirmation { "password" }
    admin { true }
    activated { true }
    activated_at { Time.zone.now }
  end

  # activation用のUserクラスを作成
  factory :activated_user, class: User do
    name { "TaroTanaka" }
    email { "testuser@test.com" }
    # password_digest { User.digest("password") }
    password { "password" }
    password_confirmation { "password" }
    admin { false }
    activated { false }
    activated_at { nil }
  end
end
