module ApplicationHelper

	# Returns the full title on a per-page basis
	def full_title(page_title)
		base_title = 'casenexus.com'
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end



	# user avatar/icon function
	def avatar_for(user)

		# load in user case count
		user_case_count = user.cases.all.count

		# categorize number of cases done by user		
		if user_case_count < 10
			avatar_colour = "white"
		elsif [user_case_count > 9, user_case_count < 25]
			avatar_colour = "yellow"
		elsif [user_case_count > 24, user_case_count < 50]
			avatar_colour = "green"
		elsif user_case_count > 25
			avatar_colour = "purple"
		end

		# build asset url
		avatar_url = "icons/avatar/user_" + avatar_colour + ".png"

		# return icon
		image_tag(avatar_url, alt: user.name, class: "avatar")
	
	end




end