require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      # get :new
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  it "未ログインの場合、ログインページにリダイレクトされること" do
    get :index
    expect(response).to have_http_status(302)
    expect(response).to redirect_to login_path
  end

  context 'ログイン有無のフォローリンク確認' do
    before do
      @user = create(:user)
      @user2 = create(:testuser)
    end

    it "followingページで未ログインだとレダイレクトされる" do
      get :following, params: { id: @user.id }
      expect(response).to redirect_to login_url
    end

    it "followersページで未ログインだとレダイレクトされる" do
      get :followers, params: { id: @user.id }
      expect(response).to redirect_to login_url
    end
  end
end
