# 本番環境での画像アップロードを調整する
# CarrierWaveを通してS3を使うように修正する

if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Amazon S3用の設定
      :provider              => 'AWS',
      :region                => ENV['S3_REGION'],     # 例: 東京のリージョン名は 'ap-northeast-1'
      :aws_access_key_id     => ENV['S3_ACCESS_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET_KEY']
    }
    config.fog_directory     =  ENV['S3_BUCKET']
  end
end

# 本番環境のメール設定と同じく Herokuの環境変数 ENV を使って、機密情報が漏洩しないようにしてる。
# heroku config:set コマンドを使って、次のようにHeroku上の環境変数を設定が必要。
# ↓
# $ heroku config:set S3_ACCESS_KEY="ココに(AWS IAMユーザーを作成した時の)Accessキーを入力"
# $ heroku config:set S3_SECRET_KEY="同様に、Secretキーを入力"
# $ heroku config:set S3_BUCKET="Bucketの名前を入力"
# $ heroku config:set S3_REGION="Regionの名前を入力"