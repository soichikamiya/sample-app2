class Relationship < ApplicationRecord
  # リレーションシップ/フォロワーに対してbelongs_toの関連付けを追加
  # active_relationship.followerでフォロワーを返し、active_relationship.followedでフォローしてるユーザーを返す
  belongs_to :follower, class_name: "User" #フォローしてる方
  belongs_to :followed, class_name: "User" #フォローされてる方

  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
