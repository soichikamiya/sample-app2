require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do
  context "ポストチェック" do
    before do
      # @user = create(:testuser)  # FactoryBot.create(:testuser)を短縮  buildだとDB登録されない
      @user = create(:testuser, name: "SoichiKamiya")
      @micropost = create(:orange)
    end

    it "ログインしていない場合 create でリダイレクトされるか" do
      post :create, params: { micropost: { content: "Lorem ipsum" } }
      expect(response).to redirect_to login_path
    end

    it "ログインしていない場合 destroy リダイレクトされるか" do
      delete :destroy, params: { id: @micropost.id }
      expect(response).to redirect_to login_path
    end
  end

  context "別ユーザーのポストを削除しようとするとリダイレクトされるか" do
    before do
      5.times { create(:user) }
      5.times { |n| create(:microposts, user: User.find(n+1)) }
    end

    it "ログインしていない場合 create でリダイレクトされるか" do
      # 当ページからログイン出来ない
      # post login_url, params: { session: { email: "Test-1@example.com", password: "Password1" } }
      micropost = Micropost.second
      expect { delete :destroy, params: { id: micropost.id } }.to change(Micropost, :count).by(0)
      expect(response).to redirect_to login_path
    end
  end
end
