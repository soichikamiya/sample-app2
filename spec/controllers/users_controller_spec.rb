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

end
