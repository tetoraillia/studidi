import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "container", "addButton"]

  add(event) {
    event.preventDefault()
    this.containerTarget.insertAdjacentHTML('beforeend', this.templateTarget.innerHTML)
    this.addButtonTarget.remove()
  }
}
