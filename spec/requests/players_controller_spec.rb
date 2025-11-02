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
        let(:players) { [] }

        before { get leaderboard_path, params: { statistic: statistic_param } }

        context "when the statistic parameter is valid" do
          let(:statistic_param) { "racing_score" }

          it "displays the leaderboard for the specified statistic" do
            expect(Player.count).to eq(0)
            expect(response).to have_http_status(:ok)
            expect(response.body).to include(I18n.t("activerecord.attributes.player.racing_score"))
          end
        end

        context "when the statistic parameter is invalid" do
          let(:statistic_param) { "invalid_statistic" }

          it "defaults to normal_score" do
            expect(Player.count).to eq(0)
            expect(response).to have_http_status(:ok)
            expect(response.body).to include(I18n.t("activerecord.attributes.player.normal_score"))
          end
        end
      end

      describe "category parameter" do
        let(:players) { [] }

        before { get leaderboard_path, params: { statistic: statistic_param } }

        context "when the statistic parameter corresponds to the normal category" do
          let(:statistic_param) { "saved_mice" }

          it "sets the category to normal" do
            expect(response.body).to include(I18n.t("players.show.categories.normal"))
          end
        end

        context "when the statistic parameter corresponds to the racing category" do
          let(:statistic_param) { "racing_firsts" }

          it "sets the category to racing" do
            expect(response.body).to include(I18n.t("players.show.categories.racing"))
          end
        end
      end

      describe "time_range parameter" do
        before { get leaderboard_path, params: { time_range: time_range_param } }

        context "when the time_range parameter is valid" do
          let(:time_range_param) { "past_7_days" }

          it "displays the leaderboard for the specified time range" do
            expect(response).to have_http_status(:ok)
            expect(response.body).to include(I18n.t("players.index.time_ranges.past_7_days"))
          end
        end

        context "when the time_range parameter is invalid" do
          let(:time_range_param) { "invalid_time_range" }

          it "defaults to all_time" do
            expect(response).to have_http_status(:ok)
            expect(response.body).to include(I18n.t("players.index.time_ranges.all_time"))
          end
        end
      end

      describe "page parameter" do
        before do
          stub_const("PlayersController::MAX_LEADERBOARD_PAGES", 2)
          stub_const("Pagy::DEFAULT", Pagy::DEFAULT.merge(limit: 1))
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

      describe "performance" do
        context "when loading the default (score-statistic) leaderboard page" do
          it "does not perform too many queries" do
            expect { get leaderboard_path }.to make_database_queries(count: 2, matching: /SELECT/)
          end
        end

        context "when selecting a non-score statistic" do
          it "does not perform too many queries" do
            expect { get leaderboard_path, params: { statistic: "saved_mice" } }
              .to make_database_queries(count: 2, matching: /SELECT/)
          end
        end

        context "when selecting a time range" do
          it "does not perform too many queries" do
            expect { get leaderboard_path, params: { time_range: "past_7_days" } }
              .to make_database_queries(count: 2, matching: /SELECT/)
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
            expect { get player_path(player) }.to make_database_queries(count: 6, matching: /SELECT/)
          end
        end

        context "when the player has no previous day change log" do
          it "does not perform too many queries" do
            expect { get player_path(player) }.to make_database_queries(count: 6, matching: /SELECT/)
          end
        end
      end
    end
  end

  describe "#search" do
    let(:user) { create(:user) }

    context "when not signed in" do
      before { get search_players_path, params: { term: "test" } }

      it "redirects to the sign-in page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      let(:get_request) { get search_players_path, params: params }

      before do
        allow(SearchService).to receive(:new).and_call_original
        sign_in(user)
      end

      context "when the search term has an exact match" do
        let(:params) { { term: exact_player.name } }
        let(:exact_player) { create(:player, name: "Noisette#0001") }

        it "redirects to the player's page" do
          get_request

          expect(response).to redirect_to(player_path(name: exact_player.name))
          expect(SearchService).not_to have_received(:new)
        end
      end

      context "when the search term is vague but valid" do
        let(:first_player) { create(:player, name: "Match#1111") }
        let(:second_player) { create(:player, name: "Match#2222") }
        let(:third_player) { create(:player, name: "Vague#2222") }
        let(:params) { { term: "match" } }

        before do
          first_player
          second_player
          third_player
        end

        it "performs a search page and displays the results" do
          get_request

          expect(response).to have_http_status(:ok)
          expect(response.body).to include(I18n.t("players.search.title"))
          expect(response.body).to include(first_player.name)
          expect(response.body).to include(second_player.name)
          expect(response.body).not_to include(third_player.name)
          expect(SearchService).to have_received(:new).with("match")
        end
      end

      context "when the search term is blank" do
        let(:params) { { term: "" } }

        it "does not perform a search and renders the search page" do
          get_request

          expect(response).to have_http_status(:ok)
          expect(response.body).to include(I18n.t("players.search.title"))
          expect(SearchService).not_to have_received(:new)
        end
      end

      context "when the search term is too short" do
        let(:params) { { term: "ab" } }

        it "does not perform a search and renders the search page" do
          get_request

          expect(response).to have_http_status(:ok)
          expect(response.body).to include(I18n.t("players.search.title"))
          expect(SearchService).not_to have_received(:new)
        end
      end

      context "when the search term contains disallowed symbols" do
        let(:params) { { term: "!!!!" } }

        it "does not perform a search and renders the search page" do
          get_request

          expect(response).to have_http_status(:ok)
          expect(response.body).to include(I18n.t("players.search.title"))
          expect(SearchService).not_to have_received(:new)
        end
      end
    end
  end
end
