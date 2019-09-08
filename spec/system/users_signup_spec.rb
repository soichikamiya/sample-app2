require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do
  context '不正なサインアップ' do
    it 'nameが空だと登録されない' do
      expect do
        post users_url, params: { user: { name: "", email: "useruser@yahoo.co.jp",
                                          password: "foobar", password_confirmation: "foobar" } }
      end.not_to change(User, :count)
      expect(response).to have_http_status(200)
      expect(response).to render_template :new
      # サーバー処理のため以下の画面(page)確認は出来ない、と思っていたがresponse.bodyでresponse内の画面確認可能
      expect(response.body).to have_selector 'div#error_explanation'
      expect(response.body).to have_selector 'div.alert-danger'
    end
  end

  context '正常なサインアップ(アカウント有効化実施)' do
    before do
      # 送信されたメールをクリア
      ActionMailer::Base.deliveries.clear
    end

    it "正しい値だと登録される" do
      expect do
        post users_url, params: { user: { name: "testuser", email: "useruser@yahoo.co.jp",
                                          password: "foobar", password_confirmation: "foobar" } }
      end.to change(User, :count).by(1)
      # メール内容確認
      user = assigns(:user) #UsersController/createの@userを取得
      expect(response).to have_http_status(302)
      expect(ActionMailer::Base.deliveries.size).to eq(1)
      expect(ActionMailer::Base.deliveries[0].from).to eq(["noreply@example.com"])
      expect(ActionMailer::Base.deliveries[0].body.encoded).to match(CGI.escape(user.email))

      # rspecだと user.activation_token が呼べなかったので再度 create_activation_digest を実行(privateメソッドなので直書き)
      user.activation_token = User.new_token
      user.update_attribute(:activation_digest, User.digest(user.activation_token))

      expect(user.activated?).to eq(false)
      # 有効化していない状態でログインしてみる
      post login_url, params: { session: { email: user.email, password: "foobar" } }
        expect(session[:user_id]).to eq(nil)
      # 有効化トークンが不正な場合
      get edit_account_activation_path("invalid token", email: user.email)
        expect(session[:user_id]).to eq(nil)
        expect(flash[:danger]).to eq("Invalid activation link")
      # トークンは正しいがメールアドレスが無効な場合
      get edit_account_activation_path(user.activation_token, email: "useruser-fake@yahoo.co.jp")
        expect(session[:user_id]).to eq(nil)
        expect(flash[:danger]).to be_present
      # 有効化トークンが正しい場合
      get edit_account_activation_path(user.activation_token, email: user.email)
      # 対応するアクション内のインスタンス変数にアクセス可能(AccountActivationsController/editの@user)
      user = assigns(:user) #これでactivatedがtrueになっているuserを呼び出せる
        expect(response).to have_http_status(302)
        expect(user.activated?).to eq(true)
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to user
        expect(flash[:success]).to be_present
        # expect(page).to have_selector 'div.alert-success'  #サーバー側の為pageの確認は不可
    end
  end
end
