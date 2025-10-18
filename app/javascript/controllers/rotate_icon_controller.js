import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["button", "iconContainer"]

    connect() {
        this.buttonTarget.addEventListener("show.bs.dropdown", () => {
            this.iconContainerTarget.classList.add("rotate-180")
        })

        this.buttonTarget.addEventListener("hide.bs.dropdown", () => {
            this.iconContainerTarget.classList.remove("rotate-180")
        })
    }
}
