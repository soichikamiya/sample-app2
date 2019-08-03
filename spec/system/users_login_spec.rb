require 'rails_helper'

RSpec.describe 'ユーザーログイン', type: :system do
  describe 'flashメッセージの確認' do

    context "サーバー側で処理" do
      it '無効なログインではflashが表示されページ遷移すると消える' do
        post login_url, params: { session: { email: "no-user@example.com", password: "123456" } }
        expect(response).to render_template :new
        expect(flash.present?).to eq(true)
        # visitはサーバー処理では無い為 flashの存在を引き継ぐ事になる
        # visit root_path
        get root_path
        expect(flash[:danger]).not_to be_present
      end
    end

    context "ビュー側で処理理" do
      it '無効なログインではflashが表示されページ遷移すると消える' do
        # 画面上のみなので response や flash のサーバー処理は使えない
        visit login_path
          fill_in 'Email', with: 'no-user@example.com'
          fill_in 'Password', with: '123456'
          click_on 'login-id'
        expect(page).to have_content 'New user? Sign up now!'
        expect(page).to have_selector 'div.alert-danger', text: 'Invalid email/password combination'
        visit root_path
        expect(page).not_to have_selector 'div.alert-danger'
      end
    end

  end
end
