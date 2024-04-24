import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["self_introduction"]

  setSelfIntroductionTarget(){
    this.self_introductionTarget.value = "■性格\n\n\n■好きなこと・趣味\n\n\n■今やっていること\n\n\n■将来どうなりたいか\n\n\n■卒業後の進路\n"
  }
}
