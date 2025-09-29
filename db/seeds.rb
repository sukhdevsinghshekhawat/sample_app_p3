# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create!(name: "sukhdev", email: "sukhdev@gmail.com", password: "123456", password_confirmation: "123456", admin: true, activated: true,
activated_at: Time.zone.now)

21.times do |n|
	name = Faker::Name.name[0, 20]
	email = "sukhdev#{n+1}@gmail.com"
	password = "123456"
   
	User.create!(name: name, email: email, password: password, password_confirmation: password, activated: true,
    activated_at: Time.zone.now)
end 
users = User.order(:created_at).take(6)   # pehle 6 users select kiye
50.times do                              
  content = Faker::Lorem.sentence(word_count: 5)   # random sentence generate
  users.each { |user| user.microposts.create!(content: content) }
end