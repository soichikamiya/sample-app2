# /app/uploaders/picture_uploader.rb
#   include CarrierWave::MiniMagick
#   process resize_to_limit: [400, 400]

# テスト時は画像のリサイズをさせない設定
if Rails.env.test?
  CarrierWave.configure do |config|
    config.enable_processing = false
  end
end
