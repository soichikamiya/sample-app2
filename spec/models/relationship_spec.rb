require 'rails_helper'

RSpec.describe Relationship, type: :model do
  context 'Relationship作成の確認' do
    before do 
      2.times { create(:user) }
      @relationship = Relationship.new(follower_id: User.first.id,
                                       followed_id: User.second.id)
    end

    it "有効かどうか" do
      expect(@relationship).to be_valid
    end

    it "follower_idは必須かどうか" do
      @relationship.follower_id = nil
      expect(@relationship).not_to be_valid
    end

    it "followed_idは必須かどう" do
      @relationship.followed_id = nil
      expect(@relationship).not_to be_valid
    end
  end
end
