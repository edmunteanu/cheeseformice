Pagy::DEFAULT[:items] = 20
Pagy::DEFAULT[:size] = 4

# Countless extra: Paginate without any count, saving one query per rendering
# See https://ddnexus.github.io/pagy/docs/extras/countless
require "pagy/extras/countless"

# Bootstrap extra: Add nav, nav_js and combo_nav_js helpers and templates for Bootstrap pagination
# See https://ddnexus.github.io/pagy/docs/extras/bootstrap
require "pagy/extras/bootstrap"

# Trim extra: Remove the page=1 param from links
# See https://ddnexus.github.io/pagy/docs/extras/trim
require "pagy/extras/trim"

# Pagy internal I18n: ~18x faster using ~10x less memory than the i18n gem
# See https://ddnexus.github.io/pagy/docs/api/i18n
Pagy::I18n.load(locale: "en", filepath: Rails.root.join("config/locales/pagy.en.yml"))

Pagy::DEFAULT.freeze
