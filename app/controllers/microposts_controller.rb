class MicropostsController < ApplicationController
  # ApplicationControllerにて logged_in_userメソッド 共通化
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # shared/feedの@feed_itemsが定義されてないと怒られる為
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    # request.referrerというメソッドで一つ前のURLを返す(テスト環境でnilになる場合があるのでroot_url追加)
    # マイクロポストがHomeページやProfileページで削除されても、DELETEリクエストが発行されたページに戻すことができ便利
    redirect_to request.referrer || root_url
    # 下記でも同じように動作する(このメソッドはRails 5から新たに導入)
    # redirect_back(fallback_location: root_url)
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      # correct_userフィルター内でfindメソッドを呼び出し、現ユーザーのみが削除対象のマイクロポストを保有しているかどうかを確認
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
