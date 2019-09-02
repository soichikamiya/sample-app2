require 'rails_helper'

RSpec.describe 'マイクロポストテスト', type: :system do
  context '各テスト' do
    before do
      # @user = create(:testuser)  # FactoryBot.create(:testuser)を短縮  buildだとDB登録されない
      @user = create(:testuser, name: "SoichiKamiya")
    end

    it '' do
      post login_url, params: { session: { email: @user.email, password: "password" } }
      expect(session[:user_id]).to eq(@user.id)
      # 無効な送信
      expect { post microposts_path, params: { micropost: { content: "" } } }.to change(Micropost, :count).by(0)
      # 有効な送信
      content = "This micropost really ties the room together"
      expect { post microposts_path, params: { micropost: { content: content } } }.to change(Micropost, :count).by(1)
      expect(response).to redirect_to root_url
      # 投稿を削除する
      micropost = @user.microposts.first
      expect { delete micropost_path(micropost) }.to change(Micropost, :count).by(-1)
      # 違うユーザーのポストを削除
      @user2 = create(:user)
      micropost2 = create(:micropost, user: @user2)
      expect { delete micropost_path(micropost2) }.to change(Micropost, :count).by(0)
      expect(response).to redirect_to root_url
    end
  end
end
