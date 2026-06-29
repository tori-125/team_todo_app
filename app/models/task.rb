class Task < ApplicationRecord
  belongs_to :user  # 私はユーザーに所属しています
  belongs_to :category, optional: true

  # 数字とステータスの言葉を紐付ける
  enum :status, { uncompleted: 0, doing: 1, completed: 2 }


  validates :title, presence: true, length: { maximum: 30 }
  validates :category, presence: true
  validates :content, length: { maximum: 500 }
end
