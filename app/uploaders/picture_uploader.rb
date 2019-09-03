class PictureUploader < CarrierWave::Uploader::Base
  # MiniMagickというImageMagickとRubyを繋ぐgemを使い画像をリサイズ
  include CarrierWave::MiniMagick
  # 縦横どちらかが400pxを超えていた場合、適切なサイズに縮小するオプション
  # cssで調整してもファイルサイズは変わらないので読み込みに時間が掛かってしまう
  process resize_to_limit: [400, 400]

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # 開発環境ではローカルのファイルシステムに画像を保存する設定であり、
  # 本番環境ではクラウドストレージサービスに画像を保存する必要がある(fog gem) ※AWSのS3登録要 /config/initializers/carrier_wave.rb
  # 現時点ではAWSを設定していないので file のままにする
  # if Rails.env.production?
  #   storage :fog
  # else
  #   storage :file
  # end
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  # アップロードファイルの保存先ディレクトリは上書き可能
  # 下記はデフォルトの保存先(publicフォルダ内)
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # アップロード可能な拡張子のリスト
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
