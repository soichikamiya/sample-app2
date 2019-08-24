require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "remember_meの確認" do
    before do
      # @user = create(:testuser)  # FactoryBot.create(:testuser)を短縮  buildだとDB登録されない
      @user = create(:testuser, name: "SoichiKamiya")
    end

    it "チェックが無い場合永続保存されないこと" do
      post :create, params: { session: { email: "testuser@test.com", password: "password", remember_me: 0 } }
      expect(response).to have_http_status(302)
      expect(session[:user_id]).to eq(@user.id)
      expect(@user.remember_digest).to eq(nil)
      expect(cookies.permanent.signed[:user_id]).to eq(nil)
      expect(cookies.permanent[:remember_token]).to eq(nil)
      expect(@user.authenticated?(:remember, cookies[:remember_token])).to eq(false)
    end

    it "チェックが有る場合永続保存されること" do
      post :create, params: { session: { email: "testuser@test.com", password: "password", remember_me: 1 } }
      expect(response).to have_http_status(302)
      expect(session[:user_id]).to eq(@user.id)
      # 何故か session_helper 内の user.remember が効かない為読み込み
      @user.remember
      # 改めて cookies[:remember_token]を更新
      cookies.permanent[:remember_token] = @user.remember_token
      expect(@user.remember_digest).not_to eq(nil)
      # cookies[:user_id]だと暗号化されたままで、下記だと複合化で確認可能
      expect(cookies.permanent.signed[:user_id]).to eq(@user.id)
      expect(cookies.permanent[:remember_token]).not_to eq(nil)
      expect(@user.authenticated?(:remember, cookies[:remember_token])).to eq(true)
    end
  end
end
