require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:mail) { UserMailer.account_activation(@user) }

    before do
      @user = create(:testuser, name: "SoichiKamiya")
      @user.activation_token = User.new_token
      # URLのhostパラメーターを設定。config/environments/test.rbで指定した為不要
      # host = '985b960af22941169449f5a59b363c0c.vfs.cloud9.ap-northeast-1.amazonaws.com'
      # Rails.application.routes.default_url_options[:host] = host
    end

    it "renders the headers" do
      expect(mail.subject).to eq("Account activation")
      expect(mail.to).to eq([@user.email])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
      expect(mail.body.encoded).to match(@user.name)
      expect(mail.body.encoded).to match(@user.activation_token)
      expect(mail.body.encoded).to match(CGI.escape(@user.email))  # エンコードされたemail
    end
  end

  describe "password_reset" do
    let(:mail) { UserMailer.password_reset }

    it "renders the headers" do
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
