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
    else
      render 'new'
    end
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
