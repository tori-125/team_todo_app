# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "初期データの作成と管理者の設定を開始します..."

# 1. チームを検索または作成
Team.find_or_create_by!(name: "運営チーム")
Team.find_or_create_by!(name: "開発チーム")
Team.find_or_create_by!(name: "営業チーム")

# 2. タスクカテゴリの作成
Category.find_or_create_by!(name: "会議")
Category.find_or_create_by!(name: "事務作業")
Category.find_or_create_by!(name: "開発")

# 3. 今作ったアカウントを「管理者」にする
my_email = "test@example.com" 

user = User.find_by(email: my_email)
if user
  user.admin! # roleを1(admin)に変更する
  puts "【成功】#{my_email} を管理者に変更しました！"
else
  puts "【警告】#{my_email} というユーザーは見つかりませんでした。アドレスが合っているか確認してください。"
end

puts "すべての処理が完了しました！"