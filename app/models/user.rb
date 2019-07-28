class User < ApplicationRecord
  # email属性を小文字に変換して全emailの一意性を保証する
  # before_save { self.email = email.downcase }
  before_save { email.downcase! }
  
  # メソッド後ろの括弧を省略できる為 validates(:name, presence: true)と同じ
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    # 大文字小文字を区別せず一意か確認
                    uniqueness: { case_sensitive: false }
end
