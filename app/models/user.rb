class User < ApplicationRecord
  has_secure_password

  # ユーザーはたくさんタスクを持っていますという設定
  has_many :tasks, dependent: :destroy

  # メールアドレスのバリデーション
  # 空っぽを禁止し、かつデータベース内で唯一（重複なし）
  validates :email, presence: true, uniqueness: true

  # 権限を判別するためのenumを追加（0: 一般スタッフ, 1: 管理者）
  enum :role, { general: 0, admin: 1 }

  belongs_to :team, optional: true
end