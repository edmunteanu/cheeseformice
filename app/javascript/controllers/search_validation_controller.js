import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["searchBar", "input"]
    static values = {
        message: String
    }

    connect() {
        this.tooltip = new bootstrap.Tooltip(this.searchBarTarget, {
            title: this.messageValue,
            trigger: "manual",
            placement: "bottom",
            template: '<div class="tooltip validation-tooltip" role="tooltip"><div class="tooltip-arrow"></div>' +
                '<div class="tooltip-inner d-flex flex-column text-start"></div></div>',
            html: true
        })
    }

    validate(event) {
        if (!this.inputTarget.checkValidity()) {
            event.preventDefault()
            this.tooltip.show()
        } else {
            this.tooltip.hide()
        }
    }
}
