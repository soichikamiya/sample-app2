require 'rails_helper'

RSpec.describe User, type: :model do
  context 'ユーザー作成の確認' do
    before do 
      @user = build(:user)  # FactoryBot.build(:user)を短縮  createだとDB登録される
      # @user = User.new(name: 'Tom', email: 'tom@example.com')
    end
    
    it 'validかどうか' do
      # trueかfalseの表示しかしない
      expect(@user.valid?).to eq(true)
      
      # 有効性確認の為 @userの中を表示する
      # expect(@user).not_to be_valid
    end

    it 'nameが空だとNG' do
      @user.name = ''
      expect(@user).not_to be_valid
    end

    it 'emailが空だとNG' do
      @user.email = '　'
      expect(@user).not_to be_valid
    end
    
    it "nameが51文字以上だとNG" do
      @user.name = 'a' * 51
      expect(@user).not_to be_valid
    end
  
    it "emailが255文字以上だとNG" do
      @user.email = 'a' * 244 + '@example.com'
      expect(@user).not_to be_valid
    end
    
    it "emailの正規表現確認" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                             foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid, "#{invalid_address.inspect} should be invalid"
      end
    end
    
    it "emailが一意でないとNG" do
      @user = User.new(name: 'Tom', email: 'tom@example.com')
      duplicate_user = @user.dup
      # 大文字小文字を区別せずエラーになるか確認
      duplicate_user.email = @user.email.upcase
      @user.save
      expect(duplicate_user).not_to be_valid
    end
    
    it "emailが小文字で登録されているか確認" do
      mixed_case_email = "Foo@ExAMPle.CoM"
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq(mixed_case_email.downcase)
    end

    it "passwordが空だとNG" do
      @user.password = @user.password_confirmation = " " * 6
      expect(@user).not_to be_valid
    end

    it "passwordが5文字以下だとNG" do
      @user.password = @user.password_confirmation = "a" * 5
      expect(@user).not_to be_valid
    end

  end
end
