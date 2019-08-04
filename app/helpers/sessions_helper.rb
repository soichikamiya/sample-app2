module SessionsHelper
  # sessionメソッドはブラウザ内の一時cookiesに、暗号化済みのユーザーIDを自動で作成する
  # cookiesメソッドとは対照的にブラウザを閉じた瞬間に有効期限が終了する
  def log_in(user)
    # 渡されたユーザーでログインする
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続的にする
  def remember(user)
    # remember_digestにランダムトークンのハッシュ値を更新
    user.remember
    # 署名付きでcookieをブラウザに保存する前に安全に暗号化する
    cookies.permanent.signed[:user_id] = user.id
    # cookies[:remember_token] = { value: remember_token, expires: 20.years.from_now.utc } と同じ
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    # 一時セッションがあれば代入
    if (user_id = session[:user_id])
      # (or equals) という代入演算子　i = i + 1 ⇨ i += 1 と同じ
      @current_user ||= User.find_by(id: user_id)
    # 永続セッションが有り、記憶トークンと記憶digestが一致すれば代入
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
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
