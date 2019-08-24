class AccountActivationsController < ApplicationController
  def edit
    # rspecで system/users_signup_spec.rb 内の assigns(:user) を呼ぶ為、ローカル変数⇨インスタンス変数に変更
    @user = User.find_by(email: params[:email])
    # 既に有効になっているユーザーを誤って再度有効化しない為に !user.activated が必要
    # 攻撃者が有効化メールURLを盗んでクリックするとログイン出来てしまう
    if @user && !@user.activated? && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = "Account activated!"
      redirect_to @user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
