class VideoQueue < ActiveRecord::Base 
	belongs_to :user
	has_many :videos, through: :queueables
	has_many :queueables

	def get_priority
	  if self.videos.size > 0
	    self.videos.max_by {|video| video.get_priority_by_user(self.user)}.get_priority_by_user(self.user) + 1
	  else
	  	1
	  end
	end

end