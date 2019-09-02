class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # buildは関連モデル作成でnewの代わり(実際newでも使用可能)
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end
