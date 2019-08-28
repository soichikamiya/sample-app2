require 'rails_helper'

RSpec.describe 'パスワード再設定', type: :system do
  describe 'reset_password' do
    let(:mail) { UserMailer.password_reset(@user) }

    before do
      ActionMailer::Base.deliveries.clear
      @user = create(:testuser, name: "SoichiKamiya")
      @user.reset_token = User.new_token
      # URLのhostパラメーターを設定。config/environments/test.rbで指定した為不要
      # host = '985b960af22941169449f5a59b363c0c.vfs.cloud9.ap-northeast-1.amazonaws.com'
      # Rails.application.routes.default_url_options[:host] = host
    end

    it "再設定の各種設定確認" do
      get new_password_reset_url
      expect(response).to have_http_status(200)

      # メールアドレスが無効
      post password_resets_path, params: { password_reset: { email: "" } }
      expect(flash[:danger]).to eq("Email address not found")
      expect(post password_resets_path, params: { password_reset: { email: "" } }).to render_template("password_resets/new")

      # メールアドレスが有効
      post password_resets_path, params: { password_reset: { email: @user.email } }
      expect(@user.reset_digest).not_to eq(@user.reload.reset_digest)
      expect(ActionMailer::Base.deliveries.size).to eq(1)
      expect(ActionMailer::Base.deliveries[0].from).to eq(["noreply@example.com"])
      expect(ActionMailer::Base.deliveries[0].body.encoded).to match(CGI.escape(@user.email))
      expect(flash[:info]).to eq("Email sent with password reset instructions")
      expect(response).to redirect_to root_url

      # パスワード再設定フォームのテスト
      user = assigns(:user)
      # メールアドレスが無効
      get edit_password_reset_path(user.reset_token, email: "")
      expect(response).to redirect_to root_url

      # 無効なユーザー
      user.toggle!(:activated)
      get edit_password_reset_path(user.reset_token, email: user.email)
      expect(response).to redirect_to root_url
      user.toggle!(:activated)

      # メールアドレスが有効で、トークンが無効
      get edit_password_reset_path('wrong token', email: user.email)
      expect(response).to redirect_to root_url

      # メールアドレスもトークンも有効
      get edit_password_reset_path(user.reset_token, email: user.email)
      expect(response).to render_template("password_resets/edit")
      # expect(page).to have_selector "input[name=email][type=hidden][value=#{user.email}]"
      expect(user).to eq(assigns(:user))

      # 無効なパスワードとパスワード確認
      patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
      @user = assigns(:user)
      expect(@user.errors.messages[:password_confirmation]).to eq(["doesn't match Password"])
      expect(response).to render_template :edit

      # パスワードが空
      patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
      @user = assigns(:user)
      expect(@user.errors.messages[:password]).to eq(["can't be blank"])
      expect(response).to render_template :edit

      # 有効なパスワードとパスワード確認
      patch password_reset_path(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
      expect(session[:user_id]).to eq(user.id)
      expect(user.reset_digest).not_to eq(user.reload.reset_digest)
      expect(user.reset_digest).to eq(nil)
      expect(flash[:success]).to eq("Password has been reset.")
      expect(response).to redirect_to user
    end

    it "期限切れのパスワード再設定" do
      get new_password_reset_url
      expect(response).to have_http_status(200)

      post password_resets_path,
           params: { password_reset: { email: @user.email } }
      expect(response).to have_http_status(302)

      @user = assigns(:user)
      @user.update_attribute(:reset_sent_at, 3.hours.ago)
      patch password_reset_path(@user.reset_token),
            params: { email: @user.email,
                      user: { password:              "foobar",
                              password_confirmation: "foobar" } }
      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_password_reset_url
      expect(flash[:danger]).to eq("Password reset has expired.")
    end
  end
end
