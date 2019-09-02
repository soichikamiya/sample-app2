FactoryBot.define do
  factory :micropost do
    content { "MyText" }
    user { nil }
  end

  factory :microposts, class: Micropost do
    # データを生成する毎に通し番号をふってユニークな値を作る
    sequence(:content) { Faker::Lorem.sentence }
    sequence(:created_at) { 42.days.ago }
    sequence(:user) { User.first }
  end

  factory :orange, class: Micropost do
    content { "I just ate an orange!" }
    user { User.first }
    created_at { 10.minutes.ago }
  end

  factory :tau_manifesto, class: Micropost do
    content { "Check out the @tauday site by @mhartl: http://tauday.com" }
    user { User.first }
    created_at { 3.years.ago }
  end

  factory :cat_video, class: Micropost do
    content { "Sad cats are sad: http://youtu.be/PKffm2uI4dk" }
    user { User.first }
    created_at { 2.hours.ago }
  end

  factory :most_recent, class: Micropost do
    content { "Writing a short test" }
    user { User.first }
    created_at { Time.zone.now }
  end
end
