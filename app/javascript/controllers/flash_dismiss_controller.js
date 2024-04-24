import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    connect() {
        this.bsAlert = window.bootstrap.Alert.getOrCreateInstance(this.element);
    }

    dismissAlert() {
        this.bsAlert.close();
    }
}
