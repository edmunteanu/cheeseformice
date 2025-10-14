require "rails_helper"

RSpec.describe ErrorsController do
  describe "#not_found" do
    before { get "/404" }

    it "is successful" do
      expect(response).to have_http_status(:not_found)
      expect(response.body).to include(I18n.t("errors.not_found.title"))
    end
  end

  describe "#internal_server_error" do
    before { get "/500" }

    it "is successful" do
      expect(response).to have_http_status(:internal_server_error)
      expect(response.body).to include(I18n.t("errors.internal_server_error.title"))
    end
  end
end
