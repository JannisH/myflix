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

	def normalize_priorities
		priority = 1
		self.videos.sort_by {|x| x.get_priority_by_user(self.user)}.each do |item|
			Queueable.find_by(video_id: item.id).update_attributes(priority: priority)
			priority += 1
		end
	end

	def change_priorities(changes)
		changes.each do |item|
			queue_item = self.queueables.find_by(video_id: item["id"])
			if(!(queue_item.priority == item["position"]))
				queue_item.priority = item["position"]
				queue_item.save
			end
		end
	end

	def update_queue(changes)
		changes.each do |change|
			item = Queueable.find(change["id"])
			item.update_attributes!(priority: change["position"], rating: change["rating"])
		end
	end
end