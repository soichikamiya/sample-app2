require 'rails_helper'

RSpec.describe '静的ページ確認', type: :system do
  describe '各画面の表示確認' do
    let(:url_root)    { visit root_path }
    let(:help_url)    { visit help_path }
    let(:about_url)   { visit about_path }
    let(:contact_url) { visit contact_path }
    
    before do
      @base_title = "Ruby on Rails Tutorial Sample App"
    end
    
    # js: trueでchromeを開きエラーの際Screenshot
    shared_examples_for '画面に Ruby on Rails が表示されている', js: true do
      it { expect(page).to have_content "Ruby on Rails" }
    end
    
    shared_examples_for 'タイトルが正常に表示されている' do
      it { expect(page).to have_title "#{@base_title}" }
    end
    
    context 'ルートURLの時' do
      before do
        url_root
      end
      it_behaves_like '画面に Ruby on Rails が表示されている'
      it_behaves_like 'タイトルが正常に表示されている'
      it '各リンクが表示されている', js: true do
        expect(page).to have_selector 'h1', text: 'Welcome to the Sample App'
        expect(page).to have_selector 'a[href="/"]', count: 2
        expect(page).to have_selector 'a[href="/help"]', text: 'Help', count: 2
        expect(page).to have_selector 'a[href="/about"]', text: 'About'
        expect(page).to have_selector 'a[href="/contact"]', text: 'Contact'
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
    
    context 'コンタクトURLの時' do
      before do
        contact_url
      end
      it_behaves_like '画面に Ruby on Rails が表示されている'
      it 'タイトルが正常に表示されている' do
        expect(page).to have_title "Contact | #{@base_title}"
      end
    end
    
    context 'サインアップURLの時' do
      before do
        visit signup_path
      end
      it_behaves_like '画面に Ruby on Rails が表示されている'
      it 'タイトルが正常に表示されている' do
        expect(page).to have_title "Sign up | #{@base_title}"
      end
    end
  end
end
