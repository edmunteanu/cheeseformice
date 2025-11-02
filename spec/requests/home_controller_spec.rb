require "rails_helper"

RSpec.describe HomeController do
  describe "#index" do
    before do
      player_execution = instance_double(GoodJob::Execution, finished_at: Time.zone.parse("2024-01-01 12:00"))
      rank_execution = instance_double(GoodJob::Execution, finished_at: Time.zone.parse("2024-01-02 12:00"))

      allow(GoodJob::Execution).to receive(:where).with(job_class: "PlayerUpdateJob").and_return([ player_execution ])
      allow(GoodJob::Execution).to receive(:where).with(job_class: "RankUpdateJob").and_return([ rank_execution ])

      get root_path
    end

    it "is successful" do
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(I18n.t("home.index.title"))
      expect(response.body).to include(I18n.t("home.index.intro"))
    end
  end
end
