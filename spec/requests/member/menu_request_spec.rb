require 'rails_helper'

RSpec.describe "Member::Menus", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/member/menu/index"
      expect(response).to have_http_status(:success)
    end
  end

end
