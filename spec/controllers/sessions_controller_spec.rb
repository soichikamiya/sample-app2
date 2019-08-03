require 'rails_helper'

RSpec.describe SessionsController, type: :system do

  describe "GET #new" do
    it "returns http success", js: true do
      get :login_path
      expect(response).to have_http_status(:success)
    end
  end

end
