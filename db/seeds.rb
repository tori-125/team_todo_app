# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "初期データの作成を開始します..."

# ここに作りたいチームの名前を書く
Team.create!(name: "運営チーム")
Team.create!(name: "開発チーム")
Team.create!(name: "営業チーム")

puts "初期データの作成が完了しました！"