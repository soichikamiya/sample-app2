class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # セッション用ヘルパーを読み込み、どのコントローラーからも使えるようにする
  include SessionsHelper
  
  def hello
    render html: "hello, world!"
  end
end
