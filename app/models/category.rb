class Category < ApplicationRecord
  # 私（カテゴリ）は、たくさんのタスクを持っています
  has_many :tasks

  acts_as_list
end
