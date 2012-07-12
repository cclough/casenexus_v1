namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do

    def randomDate(params={})
      years_back = params[:year_range] || 5
      latest_year  = params [:year_latest] || 0
      year = (rand * (years_back)).ceil + (Time.now.year - latest_year - years_back)
      month = (rand * 12).ceil
      day = (rand * 31).ceil
      series = [date = Time.local(year, month, day)]
      if params[:series]
        params[:series].each do |some_time_after|
          series << series.last + (rand * some_time_after).ceil
        end
        return series
      end
      date
    end

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

  	50.times do |n|
    	User.find(1).cases.create!(
    		:user_id => 1,
        :email => "test-#{n+1}@cases.org",
    		:marker_id => rand(100),
        :date => randomDate(:year_range => 1, :year_latest => 0),
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
     		:comment => Faker::Lorem.sentence(5),
    		:notes => Faker::Lorem.sentence(5)
    	)
		end

	end
end