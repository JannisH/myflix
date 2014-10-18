module ApplicationHelper
	def get_rating_for_user(queueable)
    	["star".pluralize(queueable.rating), queueable.rating]
  	end
end
