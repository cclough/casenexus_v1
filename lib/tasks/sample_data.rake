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
					 city: "Cambridge",
           skill: "Beginner",
           # education1: "Imperial",
           # education2: "Oxford",
           # education3: "Cambridge",
           # experience1: "MRC-T",
           # experience2: "WHO",
           # experience3: "Candesic",

           # experience1_from: "2008",
           # experience1_to: "2009",
           # experience2_from: "2009",
           # experience2_to: "2010",
           # experience3_from: "2010",
           # experience3_to: "2011",

           # education1_from: "2005",
           # education1_to: "2009",
           # education2_from: "2009",
           # education2_to: "2010",
           # education3_from: "2011",
           # education3_to: "2012",

           skype: "christianclough",
           linkedin: "christian.clough",
           num: 25)
		admin.toggle!(:admin)
    admin2 = User.create!(name: "Christian Clough",
           email: "christian.clough@gmail.com",
           password: "numbnuts",
           password_confirmation: "numbnuts",
           lat: 51.901128232665856,
           lng: -0.54241188764572144,
           country: "UK",
           city: "Oxford",
           skill: "God-like",
           # education1: "Imperial",
           # education2: "Oxford",
           # education3: "Cambridge",
           # experience1: "MRC-T",
           # experience2: "WHO",
           # experience3: "Candesic",

           # experience1_from: "2008",
           # experience1_to: "2009",
           # experience2_from: "2009",
           # experience2_to: "2010",
           # experience3_from: "2010",
           # experience3_to: "2011",

           # education1_from: "2005",
           # education1_to: "2009",
           # education2_from: "2009",
           # education2_to: "2010",
           # education3_from: "2011",
           # education3_to: "2012",

           skype: "christianclough",
           linkedin: "christian.clough",
           num: 15)
    admin2.toggle!(:admin)
		98.times do |n|
			name = Faker::Name.name
			email = "test#{n+1}@casenexus.com"
			password = "password"
			lat = -90 + rand(180)
			lng = -180 + rand(360)
			country = "US"
			city = "Boston"
      skill = "Intermediate"
      education1 = "Imperial"
      education2 = "Oxford"
      education3 = "Cambridge"
      experience1 = "MRC-T"
      experience2 = "WHO"
      experience3 = "Candesic"

      education1_to = "Imperial"
      education1_from = "Oxford"
      education2_to = "Cambridge"
      education2_from = "Cambridge"
      education3_to = "Cambridge"
      education3_from = "Cambridge"

      experience1_to = "Imperial"
      experience1_from = "Oxford"
      experience2_to = "Cambridge"
      experience2_from = "Cambridge"
      experience3_to = "Cambridge"
      experience3_from = "Cambridge"

      skype = "christianclough"
      linkedin = "christian.clough"
      num = 15
			User.create!(name: name, email: email, 
               password: password,
						   password_confirmation: password,
						   lat: lat, lng: lng, country: country,
               city: city, skill: skill)
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

    User.all.each do |user|
      10.times do
        user.messages.create!(:sender_id => rand(100), 
                              :content => Faker::Lorem.sentence(5))
      end
    end

	end
end