class Category < ActiveRecord::Base
	has_many :videos

	def recent_videos
		@videos = self.videos.all.order("created_at asc").limit(6)
	end
end