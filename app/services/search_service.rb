class SearchService
  MAX_RESULTS = 10
  SHORT_SEARCH_TERM_LENGTH = 4
  LOW_UNIQUE_CHARACTERS = 3
  INNER_MAX_RESULTS = 1_000

  def initialize(search_term)
    @search_term = search_term
  end

  # Perform a prefix search if the search term is short or has low entropy to prioritize short names.
  # Otherwise, perform a similarity search with a slight bias towards shorter names.
  def perform_search
    if short_search_term? || low_entropy?
      Player.where("name LIKE ?", "#{Player.normalize_name(@search_term)}%")
            .limit(MAX_RESULTS)
    else
      search_by_similarity
    end
  end

  private

  def short_search_term?
    @search_term.length <= SHORT_SEARCH_TERM_LENGTH
  end

  def low_entropy?
    @search_term.chars.uniq.length <= LOW_UNIQUE_CHARACTERS
  end

  def search_by_similarity
    sql = <<~SQL
            SELECT subset.*
            FROM (
              SELECT players.*
              FROM players
              WHERE name ILIKE ?
              LIMIT ?
            ) subset
            ORDER BY similarity(name, ?) - 0.03 * length(name) DESC
            LIMIT ?
          SQL
    sanitized_sql = ActiveRecord::Base.sanitize_sql_array(
      [ sql, "%#{@search_term}%", INNER_MAX_RESULTS, @search_term, MAX_RESULTS ]
    )

    Player.find_by_sql(sanitized_sql)
  end
end
