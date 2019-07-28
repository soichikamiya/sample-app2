source 'https://rubygems.org'

gem 'rails',        '5.1.6'
gem 'bootstrap-sass', '3.3.7'
gem 'puma',         '3.9.1'
gem 'sass-rails',   '5.0.6'
gem 'uglifier',     '3.2.0'
gem 'coffee-rails', '4.2.2'
gem 'jquery-rails', '4.3.1'
gem 'turbolinks',   '5.0.1'
gem 'jbuilder',     '2.7.0'

group :development, :test do
  gem 'sqlite3', '1.3.13'
  gem 'byebug',  '9.0.6', platform: :mri
  gem 'factory_bot_rails', '~> 4.11'
end

group :development do
  gem 'web-console',           '3.5.1'
  gem 'listen',                '3.1.5'
  gem 'spring',                '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
end

group :test do
  gem 'rails-controller-testing', '1.0.2'
  gem 'minitest',                 '5.10.3'
  # minitestのred, Green色分け
  gem 'minitest-reporters',       '1.1.14'
  # bundle exec guard で自動テスト開始
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
  gem 'rspec-rails',              '~> 3.7'
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara',                 '~> 2.13'
  gem 'selenium-webdriver',       '~> 3.4.1'
  # chromedriver-helperはサポート切れなので直接インストールしてPATH(which ruby)へ配置
  # Easy installation and use of chromedriver to run system tests with Chrome
  # gem 'chromedriver-helper'
  # gem 'webdrivers'
  # Springを使用し bin/rspec 実行で実行開始時間を早めることができる
  gem 'spring-commands-rspec'
end

group :production do
  gem 'pg', '0.20.0'
end

# Windows環境ではtzinfo-dataというgemを含める必要があります
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]