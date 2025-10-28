class SearchService
  MAX_RESULTS = 10
  SHORT_SEARCH_TERM_LENGTH = 3
  LOW_UNIQUE_CHARACTERS = 3

  def initialize(search_term)
    @search_term = search_term
  end

  # Perform a prefix search if the search term is short or has low entropy to improve performance.
  # Otherwise, perform a substring search with results ordered by name length and alphabetically.
  def perform_search
    if short_search_term? || low_entropy?
      Player.where("name LIKE ?", "#{Player.normalize_name(@search_term)}%")
            .limit(MAX_RESULTS)
    else
      Player.where("name ILIKE ?", "%#{@search_term}%")
            .order(Arel.sql("LENGTH(name) ASC, name ASC"))
            .limit(MAX_RESULTS)
    end
  end

  private

  def short_search_term?
    @search_term.length <= SHORT_SEARCH_TERM_LENGTH
  end

  def low_entropy?
    @search_term.chars.uniq.length <= LOW_UNIQUE_CHARACTERS
  end
end
