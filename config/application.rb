require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # モデル/コントローラー作成時に関係するrspecを自動で作成する
    config.generators do |g|
      g.test_framework :rspec,
      view_specs: false,
      helper_specs: false
    end

    # 認証トークンをremoteフォームに埋め込み、
    # ブラウザ側でJavaScriptが無効(Ajaxリクエストが送れない場合)でもJSが動くよう設定
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
