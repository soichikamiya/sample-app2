require 'rails_helper'

RSpec.describe Micropost, type: :model do
  context "micropostの有効性" do
    before do
      @user = create(:user, name: "SoichiKamiya")  # FactoryBot.build(:user)を短縮  createだとDB登録される
      # @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
      @micropost = @user.microposts.build(content: "Lorem ipsum")
    end

    it "有効かどうか" do
      expect(@micropost.valid?).to eq(true)
      expect(@micropost).to be_valid
    end

    it "ユーザーidが必須であること" do
      @micropost.user_id = nil
      expect(@micropost).not_to be_valid
    end

    it 'contentが空だとNG' do
      @micropost.content = ""
      expect(@micropost).not_to be_valid
    end

    it "contentが必須であること" do
      @micropost.content = " 　"
      expect(@micropost).not_to be_valid
    end

    it "contentは最低140文字以下であること" do
      @micropost.content = "a" * 141
      expect(@micropost).not_to be_valid
    end
  end

  context "micropostとユーザーの関係" do
    before do
      @user = create(:user, name: "SoichiKamiya")  # FactoryBot.build(:user)を短縮  createだとDB登録される
      [:orange, :tau_manifesto, :cat_video, :most_recent].each { |m| create(m) }
      @micropost = Micropost.find_by(content: "Writing a short test")
    end

    it "最新が最初に来るかどうか" do
      # default_scope -> { order(created_at: :desc) } で降順になっているため新しいのが最初に来てる
      expect(@micropost).to eq(Micropost.first)
    end

    it "関連するmicropostsも削除されること" do
      expect(@user.microposts.count).to eq(4)
      expect{ @user.destroy }.to change(Micropost, :count).by(-4)
    end
  end
end
