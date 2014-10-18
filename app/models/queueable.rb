class Queueable < ActiveRecord::Base
	belongs_to :video_queue
	belongs_to :video
	validates_uniqueness_of :video_queue_id, scope: :video_id

	def rating
		review.rating if review
	end

	def rating=(new_rating)
		if review
			review.update_column(:rating, new_rating)
		else
			review = Review.new(user_id: self.video_queue.user.id, video_id: self.video.id, rating: new_rating)
			review.save(validate: false)
		end
	end

	private

	def review 
		@review ||= Review.where(user_id: self.video_queue.user.id, video_id: self.video.id)[0]
	end
end