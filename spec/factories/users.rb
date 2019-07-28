FactoryBot.define do
  factory :user do
    # データを生成する毎に通し番号をふってユニークな値を作る
    sequence(:name) { |n| "TestName-#{n}"}
    sequence(:email) { |n| "Test-#{n}@example.com"}
  end
end
