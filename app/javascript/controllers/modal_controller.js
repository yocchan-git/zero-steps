import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  close(event) {
    if (event.detail.success) {
      window.document.getElementsByClassName('modal-backdrop')[0].remove()
      window.document.getElementsByTagName('body')[0].classList.remove('modal-open')
      window.document.getElementsByTagName('body')[0].style.removeProperty('overflow')
      window.document.getElementsByTagName('body')[0].style.removeProperty('padding-right')
    }
  }
}
