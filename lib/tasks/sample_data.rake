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

    admin = User.create!(name: "Christian Clough",
           email: "christian.clough@gmail.com",
           password: "numbnuts",
           password_confirmation: "numbnuts",
           lat: 51.901128232665856,
           lng: -0.54241188764572144,
           country: "UK",
           city: "Oxford",
           skill: "God-like",

           skype: "christianclough",
           linkedin: "christian.clough",
           num: 15,

           education1: "Imperial",
           education2: "Oxford",
           education3: "Cambridge",
           experience1: "MRC-T",
           experience2: "WHO",
           experience3: "Candesic",

           education1_from: randomDate(:year_range => 3, :year_latest => 0),
           education1_to: randomDate(:year_range => 3, :year_latest => 0),
           education2_from: randomDate(:year_range => 3, :year_latest => 0),
           education2_to: randomDate(:year_range => 3, :year_latest => 0),
           education3_from: randomDate(:year_range => 3, :year_latest => 0),
           education3_to: randomDate(:year_range => 3, :year_latest => 0),

           experience1_from: randomDate(:year_range => 3, :year_latest => 0),
           experience1_to: randomDate(:year_range => 3, :year_latest => 0),
           experience2_from: randomDate(:year_range => 3, :year_latest => 0),
           experience2_to: randomDate(:year_range => 3, :year_latest => 0),
           experience3_from: randomDate(:year_range => 3, :year_latest => 0),
           experience3_to: randomDate(:year_range => 3, :year_latest => 0))

    admin.toggle!(:admin)

    admin2 = User.create!(name: "Robin Clough",
           email: "robin.clough@gmail.com",
           password: "numbnuts",
           password_confirmation: "numbnuts",
           lat: 51.201128232665856,
           lng: -0.54241188764572144,
           country: "UK",
           city: "Oxford",
           skill: "God-like",

           skype: "robinclough",
           linkedin: "robin.clough",
           num: 15,

           education1: "Imperial",
           education2: "Oxford",
           education3: "Cambridge",
           experience1: "MRC-T",
           experience2: "WHO",
           experience3: "Candesic",

           education1_from: randomDate(:year_range => 3, :year_latest => 0),
           education1_to: randomDate(:year_range => 3, :year_latest => 0),
           education2_from: randomDate(:year_range => 3, :year_latest => 0),
           education2_to: randomDate(:year_range => 3, :year_latest => 0),
           education3_from: randomDate(:year_range => 3, :year_latest => 0),
           education3_to: randomDate(:year_range => 3, :year_latest => 0),

           experience1_from: randomDate(:year_range => 3, :year_latest => 0),
           experience1_to: randomDate(:year_range => 3, :year_latest => 0),
           experience2_from: randomDate(:year_range => 3, :year_latest => 0),
           experience2_to: randomDate(:year_range => 3, :year_latest => 0),
           experience3_from: randomDate(:year_range => 3, :year_latest => 0),
           experience3_to: randomDate(:year_range => 3, :year_latest => 0))

    admin2.toggle!(:admin)
    
    designer = User.create!(name: "Design Pro",
           email: "design@design.com",
           password: "design",
           password_confirmation: "design",
           lat: 51.221128232665856,
           lng: -0.54241188764572144,
           country: "UK",
           city: "Oxford",
           skill: "God-like",

           skype: "greatdesign",
           linkedin: "great.design",
           num: 15,

           education1: "Imperial",
           education2: "Oxford",
           education3: "Cambridge",
           experience1: "MRC-T",
           experience2: "WHO",
           experience3: "Candesic",

           education1_from: randomDate(:year_range => 3, :year_latest => 0),
           education1_to: randomDate(:year_range => 3, :year_latest => 0),
           education2_from: randomDate(:year_range => 3, :year_latest => 0),
           education2_to: randomDate(:year_range => 3, :year_latest => 0),
           education3_from: randomDate(:year_range => 3, :year_latest => 0),
           education3_to: randomDate(:year_range => 3, :year_latest => 0),

           experience1_from: randomDate(:year_range => 3, :year_latest => 0),
           experience1_to: randomDate(:year_range => 3, :year_latest => 0),
           experience2_from: randomDate(:year_range => 3, :year_latest => 0),
           experience2_to: randomDate(:year_range => 3, :year_latest => 0),
           experience3_from: randomDate(:year_range => 3, :year_latest => 0),
           experience3_to: randomDate(:year_range => 3, :year_latest => 0))

		98.times do |n|
			name = Faker::Name.name
			email = "test#{n+1}@casenexus.com"
			password = "password"
			lat = -90 + rand(180)
			lng = -180 + rand(360)
			country = "US"
			city = "Boston"
      skill = "Intermediate"

      skype = "christianclough"
      linkedin = "christian.clough"
      num = 15

      education1 = "Imperial"
      education2 = "Oxford"
      education3 = "Cambridge"
      experience1 = "MRC-T"
      experience2 = "WHO"
      experience3 = "Candesic"

      education1_to = randomDate(:year_range => 3, :year_latest => 0)
      education1_from = randomDate(:year_range => 3, :year_latest => 0)
      education2_to = randomDate(:year_range => 3, :year_latest => 0)
      education2_from = randomDate(:year_range => 3, :year_latest => 0)
      education3_to = randomDate(:year_range => 3, :year_latest => 0)
      education3_from = randomDate(:year_range => 3, :year_latest => 0)

      experience1_to = randomDate(:year_range => 3, :year_latest => 0)
      experience1_from = randomDate(:year_range => 3, :year_latest => 0)
      experience2_to = randomDate(:year_range => 3, :year_latest => 0)
      experience2_from = randomDate(:year_range => 3, :year_latest => 0)
      experience3_to = randomDate(:year_range => 3, :year_latest => 0)
      experience3_from = randomDate(:year_range => 3, :year_latest => 0)
			User.create!(name: name, email: email, 
               password: password,
						   password_confirmation: password,
						   lat: lat, lng: lng, country: country,
               city: city, skill: skill, 
               skype: skype, linkedin: linkedin, num: num,
               education1: education1, education2: education2,
               education3: education3, experience1: experience1,
               experience2: experience2, experience3: experience3,
               education1_from: education1_from, education1_to: education1_to,
               education2_from: education2_from, education2_to: education2_to,
               education3_from: education3_from, education3_to: education3_to,
               experience1_from: education1_from, experience1_to: education1_to,
               experience2_from: education2_from, experience2_to: education2_to,
               experience3_from: education3_from, experience3_to: education3_to,
               )

		end

		User.all.each do |user|
        
        if rand(2) == 1
          # create without approval
          user.posts.create!(:content => Faker::Lorem.sentence(5))
        else
          # create with approval
          user.posts.create!(:content => Faker::Lorem.sentence(5), approved: true)
        end

		end

  	50.times do |n|
    	User.find(1).cases.create!(
    		:user_id => 1,
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
        user.notifications.create!(:ntype => "message",
                                   :sender_id => rand(100), 
                                   :content => Faker::Lorem.sentence(5),
                                   :url => "http://xxx/")
        user.notifications.create!(:ntype => "feedback_new",
                                   :sender_id => rand(100), 
                                   :content => Faker::Lorem.sentence(5),
                                   :event_date => randomDate(:year_range => 1, :year_latest => 0),
                                   :url => "http://xxx/")
        user.notifications.create!(:ntype => "feedback_req",
                                   :sender_id => rand(100), 
                                   :content => Faker::Lorem.sentence(5),
                                   :event_date => randomDate(:year_range => 1, :year_latest => 0),
                                   :url => "http://xxx/")
      end
    end

	end
end