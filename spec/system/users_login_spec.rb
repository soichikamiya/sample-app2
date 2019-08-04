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

  context '正しい値でログイン' do
    before do
      # @user = create(:testuser)  # FactoryBot.create(:testuser)を短縮  buildだとDB登録されない
      @user = create(:testuser, name: "SoichiKamiya")
    end

    it 'ログイン後セッション値が登録される(サーバー)' do
      post login_url, params: { session: { email: "testuser@test.com", password: "password" } }
      expect(session[:user_id]).to eq(@user.id)
      expect(response).to redirect_to @user
      follow_redirect! #上記リダイレクト先に移動する (無くても下記のvisitで遷移可能？)
      visit user_path(@user)
      expect(page).to have_link 'Help' #なぜかログイン状態にならない
    end

    it 'ログイン後リンク表示の確認(ビュー)' do
      visit login_path
        fill_in 'Email', with: 'testuser@test.com'
        fill_in 'Password', with: 'password'
        click_on 'login-id'
      visit current_url
        click_on 'Account'
      expect(page).to have_selector 'a[href="/login"]', text: 'Log in', count: 0
      expect(page).to have_selector 'a[href="/logout"]', text: 'Log out', count: 1
      expect(page).to have_selector "a[href='/users/1']", text: "Profile"
      expect(page).to have_link 'Users'
      expect(page).to have_link 'Log in', href: login_path, count: 0
      expect(page).to have_link 'Log out', href: logout_path
      expect(page).to have_link 'Profile', href: user_path(@user), count: 1
    end
  end

  context 'ログイン後のログアウト確認' do
    before do
      # @user = create(:testuser)  # FactoryBot.create(:testuser)を短縮  buildだとDB登録されない
      @user = create(:testuser, name: "SoichiKamiya")
    end
    it do
      visit login_path
        fill_in 'Email', with: 'testuser@test.com'
        fill_in 'Password', with: 'password'
        click_on 'login-id'
      visit current_url
        click_on 'Account'
      expect(page).to have_link 'Log in', href: login_path, count: 0
      expect(page).to have_link 'Log out', href: logout_path, count: 1
      expect(page).to have_link 'Profile', href: user_path(@user), count: 1

      # サーバー処理
      delete logout_url
      expect(response).to have_http_status(302)
      expect(session[:user_id]).to eq(nil)
      expect(response).to redirect_to root_url

      visit root_url
      # ログアウトしてるのに何故かログイン状態のヘッダーになる
      expect(page).to have_link 'Log in', href: login_path, count: 0
        click_on 'Account'
        click_on 'Log out'
      expect(response).to have_http_status(302)
      expect(page).to have_content "Welcome to the Sample App"
      expect(page).to have_link 'Log in', href: login_path, count: 1
      expect(page).to have_link 'Log out', href: logout_path, count: 0
      expect(page).to have_link 'Profile', href: user_path(@user), count: 0
    end
  end
end
