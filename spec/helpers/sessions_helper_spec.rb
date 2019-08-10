require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  describe "SessionsHelper内の確認" do
    before do
      # @user = create(:testuser)  # FactoryBot.create(:testuser)を短縮  buildだとDB登録されない
      @user = create(:testuser, name: "SoichiKamiya")
    end

    it "ログインしていない場合current_userがnilであること" do
      log_out
      expect(logged_in?).to eq(false)
      expect(current_user).to eq(nil)
      expect(response).to have_http_status(200)
    end

    it "チェックが有る場合永続保存されること" do
      # 通常ログイン
      log_in(@user)
      expect(response).to have_http_status(200)
      expect(logged_in?).to eq(true)
      expect(current_user).to eq(@user)
      expect(session[:user_id]).to eq(@user.id)
      expect(cookies.permanent.signed[:user_id]).to eq(nil)
      expect(cookies.permanent[:remember_token]).to eq(nil)
      # 一度session[user_id]をdeleteし、current_userのcookies.signed[:user_id]を通るようlogout
      log_out

      # 永続ログイン
      remember(@user)
      expect(response).to have_http_status(200)
      expect(logged_in?).to eq(true)
      expect(current_user).to eq(@user)
      expect(session[:user_id]).to eq(@user.id)
      expect(cookies.permanent.signed[:user_id]).to eq(@user.id)
      expect(cookies.permanent[:remember_token]).not_to eq(nil)
      expect(@user.authenticated?(cookies[:remember_token])).to eq(true)
    end
  end
end
