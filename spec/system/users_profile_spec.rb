require 'rails_helper'

RSpec.describe 'ユーザープロフィールページ', type: :system do
  context "プロフィールページ" do
    # Applicationヘルパーを読み込むと full_titleヘルパー が利用できる
    include ApplicationHelper
    before do
      @user = create(:testuser, name: "SoichiKamiya")
      31.times { create(:microposts) }
    end

    it 'プロフィールが正しく表示されること' do
      get user_url(@user)
      expect(response).to render_template 'users/show'
      visit user_path(@user)
      expect(page).to have_title full_title(@user.name)
      expect(page).to have_selector 'h1', text: @user.name
      expect(page).to have_selector 'h1>img.gravatar'
      expect(response.body).to have_content(@user.microposts.count)
      expect(page).to have_selector 'div.pagination'
      @user.microposts.paginate(page: 1).each do |micropost|
        expect(response.body).to have_content(micropost.content)
      end
    end
  end
end
