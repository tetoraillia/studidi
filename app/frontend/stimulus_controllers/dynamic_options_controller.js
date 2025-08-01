import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "container", "addButton"]

  add(event) {
    event.preventDefault()

    if (this.containerTarget.children.length <= 2) {
      this.containerTarget.insertAdjacentHTML('beforeend', this.templateTarget.innerHTML)
      this.addButtonTarget.remove()
    } else {
      this.addButtonTarget.remove()
      alert('You can add only 3 options')
    }
  }
}
