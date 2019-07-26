require 'rails_helper'

RSpec.describe '静的ページ確認', type: :feature do
  describe '各画面表示' do
    before do
      @base_title = "Ruby on Rails Tutorial Sample App"
      visit root_url
    end
    
    context 'ルートURLの時' do
      
      it 'サクセスされる' do
        expect(page).to have_content "sample"
      end
      
      it 'タイトルが正常に表示されている' do
        expect(page).to have_title "Home | #{@base_title}"
      end
    end
  end
end



