import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["citySelect"]

  connect() {
    console.log("Province select controller connected")
  }

  change(event) {
    const provinceId = event.target.value
    if (provinceId === "") {
      this.citySelectTarget.innerHTML = '<option value="">Select a city</option>'
      return
    }

    fetch(`/cities?province_id=${provinceId}`, {
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
    })
  }
}
