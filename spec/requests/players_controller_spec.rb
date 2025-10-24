require "rails_helper"

RSpec.describe PlayersController do
  describe "#index" do
    context "when not signed in" do
      before { get leaderboard_path }

      it "redirects to the sign-in page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      let(:user) { create(:user) }
      let!(:players) do
        create_list(:player, 3).each_with_index do |player, index|
          player.category_standing.normal_rank = index + 1
          player.save!
        end
      end

      before do
        sign_in(user)
        get leaderboard_path
      end

      it "displays the player names" do
        expect(response).to have_http_status(:ok)
        players.each { |player| expect(response.body).to include(player.name) }
      end

      describe "statistic parameter" do
        before { get leaderboard_path, params: { statistic: statistic_param } }

        context "when the statistic parameter is valid" do
          let(:statistic_param) { "normal_score" }

          it "displays the leaderboard for the specified statistic" do
            expect(response).to have_http_status(:ok)
            players.each { |player| expect(response.body).to include(player.name) }
          end
        end

        context "when the statistic parameter is invalid" do
          let(:statistic_param) { "invalid_statistic" }

          it "defaults to normal_score" do
            expect(response).to have_http_status(:ok)
            players.each { |player| expect(response.body).to include(player.name) }
          end
        end
      end

      describe "category parameter" do
        context "when the statistic parameter corresponds to the normal category" do
          let(:statistic_param) { "saved_mice" }

          it "sets the category to normal" do
            expect(response.body).to include(I18n.t("players.show.categories.normal"))
          end
        end

        context "when the statistic parameter corresponds to the racing category" do
          let(:statistic_param) { "racing_firsts" }

          it "sets the category to normal" do
            expect(response.body).to include(I18n.t("players.show.categories.racing"))
          end
        end
      end

      describe "page parameter" do
        before do
          stub_const("PlayersController::MAX_LEADERBOARD_PAGES", 2)
          stub_const("Pagy::DEFAULT", Pagy::DEFAULT.merge(items: 1))
          get leaderboard_path, params: { page: page }
        end

        context "when the page parameter is lower than the maximum number of pages" do
          let(:page) { 1 }

          it "displays the page" do
            expect(response).to have_http_status(:ok)
            expect(response.body).to include(players.first.name)
            expect(response.body).not_to include(players.second.name)
            expect(response.body).not_to include(players.third.name)
          end
        end

        context "when the page parameter is equal to the maximum number of pages" do
          let(:page) { 2 }

          it "displays the last page" do
            expect(response).to have_http_status(:ok)
            expect(response.body).not_to include(players.first.name)
            expect(response.body).to include(players.second.name)
            expect(response.body).not_to include(players.third.name)
          end
        end

        context "when the page parameter is higher than the maximum number of pages" do
          let(:page) { 3 }

          it "displays the second page" do
            expect(response).to have_http_status(:ok)
            expect(response.body).not_to include(players.first.name)
            expect(response.body).to include(players.second.name)
            expect(response.body).not_to include(players.third.name)
          end
        end

        context "when the page parameter is not an integer" do
          let(:page) { "random" }

          it "displays the first page" do
            expect(response).to have_http_status(:ok)
            expect(response.body).to include(players.first.name)
            expect(response.body).not_to include(players.second.name)
            expect(response.body).not_to include(players.third.name)
          end
        end
      end
    end
  end

  describe "#show" do
    let(:player) { create(:player) }

    context "when not signed in" do
      before { get player_path(player) }

      it "redirects to the sign-in page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
        get player_path(player)
      end

      it "displays the player name" do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(player.name)
      end

      context "when the player does not exist" do
        let(:player) { build_stubbed(:player) }

        it "renders the not found page" do
          expect(response).to have_http_status(:not_found)
        end
      end

      describe "performance" do
        context "when the player has a previous day change log" do
          before { create(:change_log, player: player) }

          it "does not perform too many queries" do
            expect { get player_path(player) }.to make_database_queries(count: 4, matching: /SELECT/)
          end
        end

        context "when the player has no previous day change log" do
          it "does not perform too many queries" do
            expect { get player_path(player) }.to make_database_queries(count: 4, matching: /SELECT/)
          end
        end
      end
    end
  end

  describe "#search" do
    let(:user) { create(:user) }

    context "when not signed in" do
      before { get search_players_path, params: { term: "TestPlayer" } }

      it "redirects to the sign-in page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      before do
        sign_in(user)
        get search_players_path, params: params
      end

      context "when the search term is blank" do
        let(:params) { { term: "" } }

        # TODO: Add expectation for the SearchService not to be invoked.
        it "does not perform a search and renders the search page" do
          expect(response).to have_http_status(:ok)
          expect(response.body).to include(I18n.t("players.search.title"))
          expect(response.body).to include("small text-muted") # Does not highlight requirements
        end
      end

      context "when the search term is too short" do
        let(:params) { { term: "ab" } }

        # TODO: Add expectation for the SearchService not to be invoked.
        it "does not perform a search and renders the search page" do
          expect(response).to have_http_status(:ok)
          expect(response.body).to include(I18n.t("players.search.title"))
          expect(response.body).to include("small text-danger") # Highlights requirements
        end
      end

      context "when the search term contains disallowed symbols" do
        let(:params) { { term: "!!!!" } }

        # TODO: Add expectation for the SearchService not to be invoked.
        it "does not perform a search and renders the search page" do
          expect(response).to have_http_status(:ok)
          expect(response.body).to include(I18n.t("players.search.title"))
          expect(response.body).to include("small text-danger") # Highlights requirements
        end
      end
    end
  end
end
