class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    # follow.htmlで事前に current_user.active_relationships.build により
    # current_user の followed(following) を作成する準備(配列作成)をしていたので、
    # following << user でuserへのfollowが完成する
    current_user.follow(@user)
    # redirect_to user  #ajaxを使う為下記のrespond_toメソッドを使用
    respond_to do |format|
      # 順に実行する逐次処理ではなく、リクエストの種類によって応答を場合分けをする (if文の分岐処理に似てる)
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    # unfollow.htmlで current_user.active_relationships.find_by(followed_id: @user.id) により
    # current_userが@userをフォローしているRelationshipテーブル(id)をパラメーターとして渡し、それを削除する
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    # redirect_to user  #ajaxを使う為下記のrespond_toメソッドを使用
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
