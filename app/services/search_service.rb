class SearchService
  MAX_RESULTS = 10
  MIN_SEARCH_TERM_LENGTH = 4
  MIN_UNIQUE_CHARACTERS = 3

  def initialize(search_term)
    @search_term = search_term
  end

  # Perform a prefix search if the search term is short or has low entropy to improve performance.
  # Otherwise, perform a substring search with results ordered by name length and alphabetically.
  def perform_search
    filter = (short_search_term? || low_entropy?) ? "#{@search_term}%" : "%#{@search_term}%"

    Player.where("name ILIKE ?", filter)
          .order(Arel.sql("LENGTH(name) ASC, name ASC"))
          .limit(MAX_RESULTS)
  end

  private

  def short_search_term?
    @search_term.length < MIN_SEARCH_TERM_LENGTH
  end

  def low_entropy?
    @search_term.chars.uniq.length < MIN_UNIQUE_CHARACTERS
  end
end
