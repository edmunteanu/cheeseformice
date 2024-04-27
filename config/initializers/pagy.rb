# frozen_string_literal: true

Pagy::DEFAULT[:items] = 20
Pagy::DEFAULT[:size] = [1, 2, 2, 1]

# Bootstrap extra: Add nav, nav_js and combo_nav_js helpers and templates for Bootstrap pagination
# See https://ddnexus.github.io/pagy/docs/extras/bootstrap
require 'pagy/extras/bootstrap'

# Overflow extra: Allow for easy handling of overflowing pages
# See https://ddnexus.github.io/pagy/docs/extras/overflow
require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :last_page

# Trim extra: Remove the page=1 param from links
# See https://ddnexus.github.io/pagy/docs/extras/trim
require 'pagy/extras/trim'

Pagy::DEFAULT.freeze
