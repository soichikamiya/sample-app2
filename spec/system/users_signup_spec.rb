require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do
  context '不正なサインアップ' do
    it 'nameが空だと登録されない' do
      visit signup_path
      expect do
        post users_url, params: { user: { name: "", email: "useruser@yahoo.co.jp",
                                          password: "foobar", password_confirmation: "foobar" } }
      end.not_to change(User, :count)
      expect(response).to have_http_status(:success)
      expect(response).to render_template :new
      # expect(page).to have_selector 'div#error_explanation'
      # expect(page).to have_selector 'div.alert-danger'
    end
  end

  context '正常なサインアップ' do
    it "正しい値だと登録される" do
      visit signup_path
      expect do
        post users_url, params: { user: { name: "testuser", email: "useruser@yahoo.co.jp",
                                          password: "foobar", password_confirmation: "foobar" } }
      end.to change(User, :count).by(1)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to User.last
      # expect(page).to have_selector 'div.alert-success'
    end
  end
end
