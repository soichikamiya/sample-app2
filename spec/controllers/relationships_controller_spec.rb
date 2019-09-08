require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  context "Relationshipsアクション確認" do
    it "作成する際ログインが必要" do
      expect { post :create }.not_to change(Relationship, :count)
      assert_redirected_to login_url
    end

    it "削除する際ログインが必要" do
      2.times { create(:user) }
      relationship = create(:relationship)
      expect { delete :destroy, params: { id: relationship.id }}.not_to change(Relationship, :count)
      assert_redirected_to login_url
    end
  end
end
