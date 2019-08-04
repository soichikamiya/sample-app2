module SessionsHelper
  # sessionメソッドはブラウザ内の一時cookiesに、暗号化済みのユーザーIDを自動で作成する
  # cookiesメソッドとは対照的にブラウザを閉じた瞬間に有効期限が終了する
  def log_in(user)
    # 渡されたユーザーでログインする
    session[:user_id] = user.id
  end

  # 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    if session[:user_id]
      # (or equals) という代入演算子　i = i + 1 ⇨ i += 1 と同じ
      # @current_user = @current_user || User.find_by(id: session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
