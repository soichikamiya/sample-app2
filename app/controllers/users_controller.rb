class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    # 脆弱性があり、パッチ対策でエラーも出るので元々エラーが出る。
    # @user = User.new(params[:user])
    @user = User.new(user_params)
    if @user.save
      log_in @user
      # [success, info, warning, danger] (青、緑、黄、赤)
      flash[:success] = "Welcome to the Sample App!"
      # redirect_to user_url(@user) と同じ
      redirect_to @user
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

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
