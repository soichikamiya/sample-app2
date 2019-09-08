FactoryBot.define do
  factory :relationship do
    follower_id { 1 }
    followed_id { 2 }
  end

  factory :relationship1, class: Relationship do
    follower { User.first }
    followed { User.third }
  end

  factory :relationship2, class: Relationship do
    follower_id { 2 }
    followed_id { 1 }
  end

  factory :relationship3, class: Relationship do
    follower_id { 3 }
    followed_id { 1 }
  end
end
