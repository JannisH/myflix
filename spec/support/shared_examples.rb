	def populate_queue
		video = Video.create(title: "movie1", description: "fun")
		video2 = Video.create(title: "movie2", description: "more fun")
		review1 = Review.create(text: "great" , video_id: video.id, user_id: user.id, rating: 5)
		queue = VideoQueue.create(user_id: user.id)
		item1 = Queueable.create(video_queue_id: queue.id, video_id: video.id, priority:1)
		item2 = Queueable.create(video_queue_id: queue.id, video_id: video2.id, priority:2)
	end		

	def create_video_list(size)
		(1..size).each do |num|
			video = Video.create(title: "testMovie" + num.to_s, description: "fun movie" + num.to_s, category_id: 1)
		end
	end
