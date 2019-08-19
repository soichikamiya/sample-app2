require 'rails_helper'

RSpec.describe 'ユーザーの編集', type: :system do
  describe 'flashメッセージの確認' do

    context "編集が失敗する事" do
      before do
        # @user = create(:testuser)  # FactoryBot.create(:testuser)を短縮  buildだとDB登録されない
        @user = create(:testuser, name: "SoichiKamiya")
      end

      it '名前を空欄にすると画面遷移しない' do
        visit login_path
          fill_in 'Email', with: 'testuser@test.com'
          fill_in 'Password', with: 'password'
          click_on 'login-id'
        visit edit_user_path(@user)
          fill_in 'Name', with: ""
          fill_in 'Email', with: 'testuser@test.com'
          fill_in 'Password', with: 'password'
          fill_in 'Confirmation', with: 'password'
          click_on 'Save changes'
        expect(page).to have_http_status(:success)
        expect(current_path).to eq user_path(@user)
        expect(page).to have_content "Update your profile"
        expect(page).to have_selector 'div.alert', text: 'The form contains'
      end

      it 'ログインしていない場合ログインページに遷移されること(画面側)' do
        visit edit_user_path(@user)
        expect(page).to have_http_status(:success)
        expect(current_path).to eq login_path
        expect(page).to have_content "Please log in."
      end

      it 'ログインしていない場合ログインページに遷移されること(サーバー側)' do
        patch user_url(@user), params: { user: { name: @user.name, email: @user.email } }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to login_path
        expect(flash[:danger]).to eq "Please log in."
      end
    end
  end
end
