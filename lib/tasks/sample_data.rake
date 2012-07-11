namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		admin = User.create!(name: "Example User",
					 email: "example@railstutorial.org",
					 password: "foobar",
					 password_confirmation: "foobar",
					 lat: 51.501128232665856,
					 lng: -0.14241188764572144,
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

  	50.times do
    	User.find(1).appraisals.create!(
    		:user_id => 1,
    		:marker_id => rand(100),
    		:subject => Faker::Lorem.sentence(5),
    		:source => Faker::Lorem.sentence(5), 		
    		:plan => rand(10),
    		:plan_s => Faker::Lorem.sentence(5),
     		:analytic => rand(10),
    		:analytic_s => Faker::Lorem.sentence(5),
    		:struc => rand(10),
    		:struc_s => Faker::Lorem.sentence(5),
    		:conc => rand(10),
    		:conc_s => Faker::Lorem.sentence(5),
    		:comms => rand(10),
    		:comms_s => Faker::Lorem.sentence(5),
     		:imp => rand(10),
    		:imp_s => Faker::Lorem.sentence(5),
     		:comment => Faker::Lorem.sentence(5),
    		:notes => Faker::Lorem.sentence(5)
    	)
		end



	end
end