class SessionsController < ApplicationController
  def new
  end

  def create
    # params[:utf8]、params[:commit]、params[:controller]、params[:action] 等でも取ってこれる
    user = User.find_by(email: params[:session][:email].downcase)
    # has_secure_passwordが提供するauthenticateメソッドで、認証に失敗した時にfalseを返す
    # ユーザーがデータベースにあり、かつ認証に成功した場合にのみtrue
    if user && user.authenticate(params[:session][:password])
      
    else
      # [success, info, warning, danger] (緑、青、黄、赤)
      # flash[:danger] = 'Invalid email/password combination'
      # 上記だと画面遷移してもflashが残る。下記は次のアクションが発生するとflashが消滅する
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
  end
end
