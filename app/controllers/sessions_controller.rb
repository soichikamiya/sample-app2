class SessionsController < ApplicationController
  def new
  end

  def create
    # params[:utf8]、params[:commit]、params[:controller]、params[:action] 等でも取ってこれる
    user = User.find_by(email: params[:session][:email].downcase)
    # has_secure_passwordが提供するauthenticateメソッドで、認証に失敗した時にfalseを返す
    # ユーザーがデータベースにあり、かつ認証に成功した場合にのみtrue
    if user && user.authenticate(params[:session][:password])
      # session[:user_id] = user.id　説明はセッションヘルパー参照
      log_in user
      # 永続cookieに user.id と user.remember_token を作成
      remember user
      redirect_to user
    else
      # [success, info, warning, danger] (緑、青、黄、赤)
      # flash[:danger] = 'Invalid email/password combination'
      # 上記だと画面遷移してもflashが残る。下記は次のアクションが発生するとflashが消滅する
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    # session.delete(:user_id)
    log_out
    redirect_to root_url
  end
end
