class UsersController < ApplicationController
  # ApplicationControllerでセッション用ヘルパーを読み込み、どのコントローラーからも使えるようにしてる
  # include SessionsHelper

  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    # 有効でないユーザーは表示しない
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    # 有効でないユーザーは初期画面へ遷移
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    # 脆弱性があり、パッチ対策でエラーも出るので元々エラーが出る。
    # @user = User.new(params[:user])
    @user = User.new(user_params)
    if @user.save
      # アカウント有効化が必要な為下記はコメントアウト
      # log_in @user
      # # [success, info, warning, danger] (緑、青、黄、赤)
      # flash[:success] = "Welcome to the Sample App!"
      # # redirect_to user_url(@user) と同じ
      # redirect_to @user

      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    # Active Recordのnew_record?メソッドで post か patch かを見分けてる。User.new.new_record? ⇨ true
    # <input type="hidden" name="_method" value="patch">
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # 更新に成功した場合を扱う。
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      # adminカラムの引数(値)は許可しないように下記には記載しないようにする
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
