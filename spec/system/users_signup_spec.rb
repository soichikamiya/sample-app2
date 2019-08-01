require 'rails_helper'

RSpec.describe '不正なサインアップ', type: :system do
  it 'nameが空だと登録されない', js: true do
    visit signup_path
    expect do
      post users_url, params: { user: { name: "", email: "useruser@yahoo.co.jp", 
                                        password: "foobar", password_confirmation: "foobar" } }
    end.not_to change(User, :count)
    # end.to change(User, :count).by(1)
    expect(response).to have_http_status(:success)
    expect(response).to render_template :new
    # expect(response).to redirect_to User.last
    # expect(page).to have_selector 'div#error_explanation'
    # expect(page).to have_selector 'div.alert-danger'
  end
end
