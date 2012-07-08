namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		admin = User.create!(name: "Example User",
					 email: "example@railstutorial.org",
					 password: "foobar",
					 password_confirmation: "foobar",
					 lat: "51.5",
					 lng: "5",
					 loc: "St James, London")
		admin.toggle!(:admin) 
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password = "password"
			lat = -50 + rand(100)
			lng = -50 + rand(100)
			loc = Faker::Address.city
			User.create!(name: name, email: email, password: password,
						 password_confirmation: password,
						 lat: lat, lng: lng, loc: loc)
		end
	end
end