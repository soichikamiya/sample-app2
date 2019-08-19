FactoryBot.define do
  factory :user do
    # データを生成する毎に通し番号をふってユニークな値を作る
    sequence(:name) { |n| "TestName-#{n}"}
    sequence(:email) { |n| "Test-#{n}@example.com"}
    sequence(:password) { |n| "Password#{n}"}
    sequence(:password_confirmation) { |n| "Password#{n}"}
  end

  # Userクラスでモデル名以外の名前を作成
  factory :testuser, class: User do
    name { "TaroTanaka" }
    email { "testuser@test.com" }
    # password_digest { User.digest("password") }
    password { "password" }
    password_confirmation { "password" }
    admin { true }
  end
end
