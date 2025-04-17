# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# カテゴリの作成
categories = [
    "ギター",
    "ベース",
    "ドラム",
    "ピアノ",
    "キーボード",
    "金管楽器",
    "木管楽器",
    "弦楽器",
    "打楽器",
    "民族楽器",
    "録音機材",
    "その他"
]

categories.each do |name|
    Category.find_or_create_by(name: name)
end


