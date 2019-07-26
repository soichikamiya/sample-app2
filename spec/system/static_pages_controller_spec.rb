require 'rails_helper'

RSpec.describe '静的ページ確認', type: :system do
  describe '各画面の表示確認' do
    let(:url_root)  { visit root_url }
    let(:home_url)  { visit static_pages_home_url }
    let(:help_url)  { visit static_pages_help_url }
    let(:about_url) { visit static_pages_about_url }
    
    before do
      @base_title = "Ruby on Rails Tutorial Sample App"
    end
    
    # js: trueでchromeを開きエラーの際Screenshot
    shared_examples_for '画面に Ruby on Rails が表示されている', js: true do
      it { expect(page).to have_content "Ruby on Rails" }
    end
    
    context 'ルートURLの時' do
      before do
        url_root
      end
      # shared_examples_for から呼び出し
      it_behaves_like '画面に Ruby on Rails が表示されている'
      it 'タイトルが正常に表示されている' do
        expect(page).to have_title "Home | #{@base_title}"
      end
    end
    
    context 'ホームURLの時' do
      before do
        home_url
      end
      it_behaves_like '画面に Ruby on Rails が表示されている'
      it 'タイトルが正常に表示されている' do
        expect(page).to have_title "Home | #{@base_title}"
      end
    end
    
    context 'ヘルプURLの時' do
      before do
        help_url
      end
      it_behaves_like '画面に Ruby on Rails が表示されている'
      it 'タイトルが正常に表示されている' do
        expect(page).to have_title "Help | #{@base_title}"
      end
    end
    
    context 'アバウトURLの時' do
      before do
        about_url
      end
      it_behaves_like '画面に Ruby on Rails が表示されている'
      it 'タイトルが正常に表示されている' do
        expect(page).to have_title "About | #{@base_title}"
      end
    end
  end
end
