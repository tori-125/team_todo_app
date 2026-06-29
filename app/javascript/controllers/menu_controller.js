// 三点リーダーメニュー

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // 動かしたい対象（今回はドロップダウンメニュー）を登録する
  static targets = ["dropdown"]

  // 三点リーダーをクリックした時の処理
  toggle(event) {
    event.preventDefault()
    event.stopPropagation() // クリック判定が外に広がるのを防ぐ
    this.dropdownTarget.classList.toggle("active")
  }

  // 画面のどこかをクリックした時にメニューを閉じる処理
  close(event) {
    // クリックされた場所がメニュー全体（this.element）の外側だった場合のみ閉じる
    if (!this.element.contains(event.target)) {
      this.dropdownTarget.classList.remove("active")
    }
  }
}