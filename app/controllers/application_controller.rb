class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # セッション用ヘルパーを読み込み、どのコントローラーからも使えるようにする
  include SessionsHelper

  def hello
    render html: "hello, world!"
  end

  private

    # ユーザーのログインを確認する(どのcontrollerからも参照可能)
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
