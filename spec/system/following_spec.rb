require 'rails_helper'

RSpec.describe 'フォローページ', type: :system do
  context "" do
    # Applicationヘルパーを読み込むと full_titleヘルパー が利用できる
    include ApplicationHelper

    let(:login_method) do
      post login_url, params: { session: { email: @user.email, password: "password" } }
      expect(session[:user_id]).to eq(@user.id)
      expect(response).to redirect_to @user
    end

    let(:create_relationship) do
      rel = [:relationship,:relationship1,:relationship2,:relationship3]
      4.times { |n| create(rel[n]) }
    end

    before do
      @user = create(:testuser)
      3.times { create(:user) }
    end

    it 'following page' do
      login_method
      create_relationship
      get following_user_path(@user)
      expect(response).to render_template 'users/show_follow'
      expect(@user.following.empty?).to eq(false)
      expect(response.body).to have_content @user.following.count.to_s
      expect(response.body).to have_content @user.following.count
      expect(@user.following.count).to eq(2)
      @user.following.each do |user|
        expect(response.body).to have_selector "a[href='#{user_path(user)}']"
      end
    end

    it 'followers page' do
      login_method
      create_relationship
      get followers_user_path(@user)
      expect(response).to render_template 'users/show_follow'
      expect(@user.followers.empty?).to eq(false)
      expect(response.body).to have_content @user.followers.count.to_s
      expect(response.body).to have_content @user.followers.count.to_s
      expect(@user.followers.count).to eq(2)
      @user.followers.each do |user|
        expect(response.body).to have_selector "a[href='#{user_path(user)}']"
      end
    end

    it "html通信(通常通信)でユーザーをフォローする" do
      login_method
      @other = User.second
      expect { post relationships_path, params: { followed_id: @other.id } }.to change(@user.following, :count).by(1)
    end

    it "ajax通信でユーザーをフォローする" do
      login_method
      @other = User.second
      # xhr (XmlHttpRequest) というオプションをtrueに設定し、Ajaxでリクエストを発行するよう変更
      expect { post relationships_path, xhr: true, params: { followed_id: @other.id } }.to change(@user.following, :count).by(1)
    end

    it "html通信(通常通信)でユーザーをアンフォローする" do
      login_method
      @other = User.second
      @user.follow(@other)
      relationship = @user.active_relationships.find_by(followed_id: @other.id)
      expect { delete relationship_path(relationship) }.to change(@user.following, :count).by(-1)
    end

    it "ajax通信でユーザーをアンフォローする" do
      login_method
      @other = User.second
      @user.follow(@other)
      relationship = @user.active_relationships.find_by(followed_id: @other.id)
      # xhr (XmlHttpRequest) というオプションをtrueに設定し、Ajaxでリクエストを発行するよう変更
      expect { delete relationship_path(relationship), xhr: true }.to change(@user.following, :count).by(-1)
    end
  end
end
