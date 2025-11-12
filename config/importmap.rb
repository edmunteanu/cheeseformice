# Pin npm packages by running ./bin/importmap

pin "application"

# Core Rails JS
pin "@rails/actioncable", to: "actioncable.esm.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Bootstrap JS
pin "popper", to: "popper.js"
pin "bootstrap", to: "bootstrap.min.js"

# Pagy JS
pin "pagy", to: "pagy.min.js", preload: true
