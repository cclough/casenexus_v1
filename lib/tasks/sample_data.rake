namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		admin = User.create!(name: "Example User",
					 email: "example@railstutorial.org",
					 password: "foobar",
					 password_confirmation: "foobar",
					 lat: "51.5",
					 lng: "5",
					 country: "UK",
					 city: "London")
		admin.toggle!(:admin) 
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password = "password"
			lat = -90 + rand(180)
			lng = -180 + rand(360)
			country = Faker::Address.country
			city = Faker::Address.city
			User.create!(name: name, email: email, password: password,
						 password_confirmation: password,
						 lat: lat, lng: lng, country: country, city: city)
		end

		User.all.each do |user|
      		2.times do
        		user.posts.create!(:content => Faker::Lorem.sentence(5))
			end
		end
	end
end