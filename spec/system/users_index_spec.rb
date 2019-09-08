require 'rails_helper'

RSpec.describe 'ユーザー一覧', type: :system do
  describe '一覧ページ' do
    before do
      # @user = create(:testuser)  # FactoryBot.create(:testuser)を短縮  buildだとDB登録されない
      @user = create(:testuser)
      31.times { create(:user) }
    end

    it 'ページネーションが含まれているかどうか' do
      visit login_path
        fill_in 'Email', with: @user.email
        fill_in 'Password', with: 'password'
        click_on 'login-id'
      visit users_path
      expect(page).to have_content "All users"
      expect(page).to have_selector 'div.pagination', count: 2
      User.paginate(page: 1).each do |user|
        expect(page).to have_selector "a[href='/users/#{user.id}']", text: user.name
      end
    end
  end

  describe '一覧ページ削除' do
    before do
      # @user = create(:testuser)  # FactoryBot.create(:testuser)を短縮  buildだとDB登録されない
      @user = create(:testuser, name: "SoichiKamiya")
      31.times { create(:user) }
    end

    it 'ログインしていない場合ログインページに遷移すること' do
      delete user_url(User.second)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to login_url
    end

    it 'adminユーザーでログインしていない場合ログインページに遷移すること' do
      visit login_path
        fill_in 'Email', with: 'Test-1@example.com'
        fill_in 'Password', with: 'Password1'
        click_on 'login-id'
      delete user_url(User.second)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to login_url
    end

    it 'adminユーザーだと削除が表示' do
      visit login_path
        fill_in 'Email', with: 'testuser@test.com'
        fill_in 'Password', with: 'password'
        click_on 'login-id'
      visit users_path
      expect(page).to have_content "All users"
      expect(page).to have_selector 'div.pagination', count: 2
      User.paginate(page: 1).each do |user|
        expect(page).to have_selector "a[href='/users/#{user.id}']", text: user.name
        unless user == @user
          expect(page).to have_selector "a[href='/users/#{user.id}']", text: "delete"
        end
      end
    end

    it 'adminユーザー以外だと削除非表示',js:true do
      @user.update_attribute(:admin, false)
      visit login_path
        fill_in 'Email', with: @user.email
        fill_in 'Password', with: 'password'
        click_on 'login-id'
      visit users_path
      expect(page).to have_content "All users"
      expect(page).to have_selector 'div.pagination', count: 2
      User.paginate(page: 1).each do |user|
        expect(page).to have_selector "a[href='/users/#{user.id}']", text: "delete", count: 0
      end
    end

    it 'adminユーザーだと削除可能' do
      post login_url, params: { session: { email: "testuser@test.com", password: "password", remember_me: 1 } }
      expect { delete user_url(User.second) }.to change(User, :count).by(-1)
      expect(response).to have_http_status(302)
      expect(flash[:success]).to eq("User deleted")
      expect(response).to redirect_to users_url
    end

    it 'adminユーザー以外だと削除不可' do
      @user.update_attribute(:admin, false)
      post login_url, params: { session: { email: "testuser@test.com", password: "password", remember_me: 0 } }
      expect { delete user_url(User.second) }.to change(User, :count).by(0)
      expect(response).to have_http_status(302)
      expect(flash[:success]).to eq(nil)
      expect(response).to redirect_to root_url
    end

  end
end
